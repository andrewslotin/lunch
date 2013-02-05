# -*- encoding : utf-8 -*-

class Place
  include Mongoid::Document

  ADDRESS_FIELDS = ["address".freeze, "city".freeze, "state".freeze, "country".freeze, "postalCode".freeze].freeze

  WIMDU_LAT = "52.49402952426317"
  WIMDU_LNG = "13.429402830064818"

  field :name, type: String
  field :distance, type: Integer, default: 0
  field :url, type: String
  field :category, type: String, default: "Food"
  field :location, type: Array, default: [0, 0]
  field :address, type: Hash, default: Hash[ADDRESS_FIELDS.zip([""] * ADDRESS_FIELDS.size)]
  field :rating, type: Float, default: 0.0
  field :_id, type: String, default: -> { foursquare_id }

  has_many :votes, dependent: :destroy

  index({ location: "2d" }, { background: true })

  attr_accessor :foursquare_id

  validate :check_location_format

  def self.around(lat, lng, radius = 500)
    foursquare_results = foursquare.explore_venues(ll: [lat, lng].join(","), section: :food, radius: radius)
    foursquare_results["groups"].map do |group|
      group["items"].map do |item|
        venue = item["venue"]

        v = self.find_or_create_by(_id: venue["id"]) do |place|
          place.foursquare_id = venue["id"]
          place.name     = venue["name"]
          place.url      = venue["canonicalUrl"]
          place.location = [venue["location"]["lat"], venue["location"]["lng"]]
          place.distance = venue["location"]["distance"]
          place.rating   = venue["rating"] || 0.0

          place.address = Hash[ADDRESS_FIELDS.zip(venue["location"].values_at(*ADDRESS_FIELDS))]
        end

        v.rating = venue["rating"] || 0.0
        v.save if v.rating_changed?

        v
      end
    end.flatten

    self.scoped
  end

  def full_address
    [address["address"], city_with_zip].select(&:presence).join(", ")
  end

  def city_with_zip
    [address["postalCode"], address["city"]].select(&:presence).join(" ") if address["city"].present?
  end

  private

  def self.foursquare
    Foursquare2::Client.new(client_id: ENV['FOURSQUARE_CLIENT_ID'], client_secret: ENV['FOURSQUARE_CLIENT_SECRET'])
  end

  def check_location_format
    location.size == 2
  end
end
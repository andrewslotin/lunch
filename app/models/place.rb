# -*- encoding : utf-8 -*-

class Place
  include Gmaps4rails::ActsAsGmappable

  attr_reader :name, :distance, :url, :category, :lat, :lng

  def self.around(lat, lng, radius = 500)
    foursquare_results = if Rails.env.development?
                           JSON.load(File.read("data.json"))
                         else
                           foursquare.explore_venues(ll: [lat, lng].join(","), section: :food, radius: radius)
                         end
    foursquare_results["groups"].map do |group|
      group["items"].map do |venue|
        self.new(venue["venue"])
      end
    end.flatten
  end

  def initialize(foursquare_hash)
    @name = foursquare_hash["name"]
    @url = foursquare_hash["canonicalUrl"]
    @lat = foursquare_hash["location"]["lat"]
    @lng = foursquare_hash["location"]["lng"]
    @distance = foursquare_hash["location"]["distance"]

    address_fields = %w(address city state country postalCode)
    @address = Hash[address_fields.map(&:to_sym).zip(foursquare_hash["location"].values_at(*address_fields))]
  end

  def address
    [@address[:address], city_with_zip].select(&:presence).join(", ")
  end

  def city_with_zip
    [@address[:postalCode], @address[:city]].select(&:presence).join(" ") if @address[:city].present?
  end

  private

  def self.foursquare
    Foursquare2::Client.new(client_id: ENV['FOURSQUARE_CLIENT_ID'], client_secret: ENV['FOURSQUARE_CLIENT_SECRET'])
  end
end
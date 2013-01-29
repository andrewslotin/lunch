# -*- encoding : utf-8 -*-

class Place
  def self.around(lat, lng, radius = 500)
    foursquare.explore_venues(ll: [lat, lng].join(","), section: :food, radius: radius)
  end

  private

  def self.foursquare
    Foursquare2::Client.new(client_id: ENV['FOURSQUARE_CLIENT_ID'], client_secret: ENV['FOURSQUARE_CLIENT_SECRET'])
  end
end
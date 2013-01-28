class PlacesController < ApplicationController
  def index
    lat = "52.49402952426317"
    lng = "13.429402830064818"
    client = Foursquare2::Client.new(client_id: ENV['FOURSQUARE_CLIENT_ID'], client_secret: ENV['FOURSQUARE_CLIENT_SECRET'])
    @venues = client.explore_venues(ll: [lat, lng].join(","), section: :food, radius: 500)
  end
end

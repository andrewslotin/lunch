class PlacesController < ApplicationController
  def index
    lat = "52.49402952426317"
    lng = "13.429402830064818"
    @venues = Place.around(lat, lng)
  end
end

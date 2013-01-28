class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    client = Foursquare2::Client.new(client)
  end
end

# -*- encoding : utf-8 -*-

class PlacesController < ApplicationController
  respond_to :json, :html
  helper_method :resource, :collection

  def index
    respond_to do |format|
      format.html
      format.json { render json: collection }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: resource }
    end
  end

  def vote
    unless current_user.vote_for! resource
      flash[:error] = "Something went wrong :("
    end

    redirect_to :back
  end

  def unvote
    current_user.votes.current.destroy

    redirect_to :back
  end

  def like
    resource.votes.unrated.last.like!

    flash[:notice] = "Thanks!"
    redirect_to :back
  end

  def dislike
    resource.votes.unrated.last.dislike!

    flash[:notice] = "Better luck next time"
    redirect_to :back
  end

  protected

  def resource
    @_place ||= Place.find(params[:id])
  end

  def collection
    @_places ||= Place.around(location_parameters[:lat] || Place::WIMDU_LAT, location_parameters[:lng] || Place::WIMDU_LNG).sort_by(&:rating)
  end

  private

  def location_parameters
    params.permit(:lat, :lng)
  end
end

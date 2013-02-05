class PlacesController < InheritedResources::Base
  def index
    @venues = Place.around(WIMDU_LAT, WIMDU_LNG).desc(:rating)
  end

  def vote
    unless current_user.vote_for! resource
      flash[:error] = "Something went wrong :("
    end

    redirect_to places_path
  end

  def like
    resource.votes.unrated.last.like!

    flash[:notice] = "Thanks!"
    redirect_to places_path
  end

  def dislike
    resource.votes.unrated.last.dislike!

    flash[:notice] = "Better luck next time"
    redirect_to places_path
  end
end

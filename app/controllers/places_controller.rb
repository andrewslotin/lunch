class PlacesController < InheritedResources::Base
  def index
    @venues = Place.around(Place::WIMDU_LAT, Place::WIMDU_LNG).desc(:rating)
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
end

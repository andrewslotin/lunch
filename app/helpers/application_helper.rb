module ApplicationHelper
  WALKING_SPEED = 5.5
  RUNNING_SPEED = 12.0

  def link_to_venue(venue)
    link_to venue.name, venue.url
  end

  def walking_time(distance)
    (distance / WALKING_SPEED).ceil
  end

  def running_time(distance)
    (distance / RUNNING_SPEED).ceil
  end
end

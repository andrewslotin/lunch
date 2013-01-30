module ApplicationHelper
  WALKING_SPEED = 5500.0 / 3600
  RUNNING_SPEED = 12000.0 / 3600

  def link_to_venue(venue)
    link_to venue.name, venue.url
  end

  def walking_time(distance)
    time_for_distance(distance, WALKING_SPEED)
  end

  def running_time(distance)
    time_for_distance(distance, RUNNING_SPEED)
  end

  private

  def time_for_distance(distance, speed)
    (distance / speed).ceil
  end
end

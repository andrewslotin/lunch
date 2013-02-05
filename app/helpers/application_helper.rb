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

  def days_ago_in_words(time)
    difference_in_days = if time.respond_to? :to_date
                           (Time.zone.now.to_date - time.to_date).to_i
                         elsif time.is_a? Numeric
                           pluralize time.to_i
                         else
                           nil
                         end

    if difference_in_days.nil?
      !!time ? "previously" : "never"
    elsif difference_in_days < 0
      "never"
    elsif difference_in_days == 0
      "today"
    elsif difference_in_days == 1
      "yesterday"
    else
      "#{pluralize(difference_in_days, "day")} ago"
    end
  end

  private

  def time_for_distance(distance, speed)
    (distance / speed).ceil
  end
end

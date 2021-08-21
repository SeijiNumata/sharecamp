# frozen_string_literal: true

class WatchedEvent
  def self.push_recent_watched(event, recent_watched_event_cookies)
    if recent_watched_event_cookies.nil?
      [event.id.to_s]
    else
      recent_watched_events = JSON.parse(recent_watched_event_cookies)
      recent_watched_events.push(event.id).uniq!
      recent_watched_array_number = 5
      recent_watched_events.slice!(0..recent_watched_events.count - (recent_watched_array_number + 1)) if recent_watched_events.count > recent_watched_array_number
    end
    JSON.generate(recent_watched_events)
  end

  def self.recent_watched_events(recent_watched_event_cookies)
    return unless recent_watched_event_cookies

    Event.where(id: JSON.parse(recent_watched_event_cookies)).order('updated_at DESC')
  end
end

# frozen_string_literal: true

module ApplicationHelper
  def page_title(separator = ' – ')
    [content_for(:title), 'SHARECAMP'].compact.join(separator)
  end

  def page_heading(title)
    content_for(:title) { title }
  end

  def recent_watched_events_count
    if cookies[:recent_watched_events]

      JSON.parse(cookies[:recent_watched_events]).count
    else
      0

    end
  end
end

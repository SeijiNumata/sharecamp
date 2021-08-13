# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = recent_watched_events
  end

  def show
    set_came_from_event_create
    session[:event_id] = @event.id
    redirect_to '/events/users/new' unless current_user

    push_recent_watched_cookies(@event)
  end

  def new
    session[:from_event_create] = 'from_event_create'
  end

  def edit; end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name)
  end

  def push_recent_watched_cookies(event)
    if cookies[:recent_watched_events].nil?
      recent_watched_events = [event.id.to_s]
    else
      recent_watched_events = JSON.parse(cookies[:recent_watched_events])
      recent_watched_events.push(event.id).uniq!
      recent_watched_array_number = 5
      if recent_watched_events.count > recent_watched_array_number
        recent_watched_events.slice!(0..recent_watched_events.count - (recent_watched_array_number + 1))
      end
    end
    cookies[:recent_watched_events] = JSON.generate(recent_watched_events)
  end

  def set_came_from_event_create
    return unless session[:from_event_create]

    @from_event_create = session[:from_event_create]

    session.delete(:from_event_create)
  end

  def recent_watched_events
    return unless cookies[:recent_watched_events]

    Event.where(id: JSON.parse(cookies[:recent_watched_events])).order('updated_at DESC')
  end
end

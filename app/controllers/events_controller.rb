# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = []
    return unless cookies[:recent_watch_events]

    set_recent_watch_event(JSON.parse(cookies[:recent_watch_events]))
  end

  def show
    from_create_check
    session[:event_id] = @event.id
    redirect_to '/events/users/new' unless current_user

    set_recent_watch_cookies(@event)
  end

  def new
    session[:from_create] = 'from_create'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name)
  end

  def set_recent_watch_cookies(event)
    if cookies[:recent_watch_events].nil?
      recent_watch_events = [event.id.to_s]
    else
      recent_watch_events = JSON.parse(cookies[:recent_watch_events])
      recent_watch_events.push(event.id).uniq!
      recent_watch_array_number = 5
      if recent_watch_events.count > recent_watch_array_number
        recent_watch_events.slice!(0..recent_watch_events.count - (recent_watch_array_number + 1))
      end
    end
    cookies[:recent_watch_events] = JSON.generate(recent_watch_events)
  end

  def from_create_check
    return unless session[:from_create]

    @from_create = session[:from_create]

    session.delete(:from_create)
  end

  def set_recent_watch_event(recent_watch_events)
    recent_watch_events.each do |event_id|
      if Event.exists?(id: event_id) == false
        @events = []
        break
      end
      @events.push(Event.find(event_id))
    end
    @events.reverse!
  end
end

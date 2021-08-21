# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = WatchedEvent.recent_watched_events(cookies[:recent_watched_events])
  end

  def show
    set_came_from_event_create
    session[:event_id] = @event.id
    redirect_to '/events/users/new' unless current_user
    cookies[:recent_watched_events] = WatchedEvent.update_recent_watched(@event, cookies[:recent_watched_events] ||= '')
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

  def set_came_from_event_create
    return unless session[:from_event_create]

    @from_event_create = session[:from_event_create]

    session.delete(:from_event_create)
  end
end

# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = recent_watched_events
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

  def edit; end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name)
  end

  def set_recent_watch_cookies(event)
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

  def from_create_check
    return unless session[:from_create]

    @from_create = session[:from_create]

    session.delete(:from_create)
  end

  def recent_watched_events
    return unless cookies[:recent_watched_events]

    events = JSON.parse(cookies[:recent_watched_events]).map do |event_id|
      Event.find(event_id)
    end

    events.reverse!
  end
end

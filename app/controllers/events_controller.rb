# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = []
    return unless cookies[:recent_watch_events]

    set_recent_watch_event(JSON.parse(cookies[:recent_watch_events]))
  end

  def show
    set_from_event_create
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

  def set_from_event_create
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

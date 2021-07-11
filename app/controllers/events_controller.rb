# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events or /events.json
  def index
    @events = []
    recent_watch_events = JSON.parse(cookies[:recent_watch_events])
    recent_watch_events.each do |event_id|
      @events.push(Event.find(event_id))
    end
    @events.reverse!
  end

  # GET /events/1 or /events/1.json
  def show
    from_create_check

    session[:event_id] = @event.id
    redirect_to '/events/users/new' unless current_user

    set_recent_watch_cookies(@event)
  end

  # GET /events/new
  def new
    # @event = Event.new
    # User.find_by(id: cookies.signed[:user_id])
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  # def create
  #   @event = Event.new(event_params)

  #   respond_to do |format|
  #     if @event.save
  #       format.html { redirect_to @event, notice: 'Event was successfully created.' }
  #       format.json { render :show, status: :created, location: @event }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @event.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name)
  end

  def set_recent_watch_cookies(event)
    if cookies[:recent_watch_events].nil?
      recent_watch_events = [event.id.to_s]
    else
      recent_watch_events = JSON.parse(cookies[:recent_watch_events])
      recent_watch_events.push(event.id).uniq!
      recent_watch_events.slice!(0..recent_watch_events.count - 6) if recent_watch_events.count > 5
    end

    cookies[:recent_watch_events] = JSON.generate(recent_watch_events)
  end

  def from_create_check
    return unless session['fromCreate']

    @from_create = session['fromCreate']
    session.delete('fromCreate')
  end
end

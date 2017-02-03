# frozen_string_literal: true
class EventsController < ApplicationController
  # exposes
  expose(:events) { Event.all_but([highlight]) }
  expose(:event, attributes: :event_attributes)

  PER_PAGE = 10

  def index
    self.events = paginated_events
  end

  private

  def resource
    event
  end

  def resource_title
    event.title
  end

  def index_path
    events_path
  end

  def show_path
    event_path(resource)
  end

  def resource_params
    event_params
  end

  # Filtering

  def paginated_events
    filtered_event.page(params[:page]).per(PER_PAGE)
  end

  def filtered_event
    events.filter_by(searched_events, params.fetch(:filter, ''))
  end

  def searched_events
    events.search(nil, params.fetch(:search, ''))
  end
end

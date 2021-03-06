class EventsController < ApplicationController
  include IcalHelper

  expose(:events) { Event.ordered.page(params[:page]) }
  expose(:event)  { Event.includes(materials: :user, topics: :user, participants: :user).from_param(params[:id]) }

  def index
    respond_to do |format|
      format.html
      format.xml  { render layout: false }
      format.json { render json: events.as_api_response(:ios_v1) }
      format.ics  { render plain: icalendar(*events) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        render json: event.as_api_response(:ios_v1)
      end
      format.ics do
        render plain: icalendar(event)
      end
    end
  end
end

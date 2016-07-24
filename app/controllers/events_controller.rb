# create_table "events", force: :cascade do |t|
#   t.datetime "starts_at"
#   t.datetime "ends_at"
#   t.integer  "venue_id"
#   t.string   "hero_image_url"
#   t.text     "extended_html_description"
#   t.integer  "category_id"
#   t.string   "name"
#   t.datetime "created_at",                null: false
#   t.datetime "updated_at",                null: false
# end

class EventsController < ApplicationController
  def index
    @events = Event.upcoming.search(params[:search])
  end

  def full
    @events = Event.all
  end

  def new
    @event = Event.new
    @categories = Category.all
    @venues = Venue.all
  end

  def create    
    @categories = Category.all
    @venues = Venue.all
    @event = current_user.events.new(event_params)
    @event.venue_id ||= 1
    @event.category_id ||= 1
    if @event.save
      flash[:notice] = "Event created"
      redirect_to root_path
    else
      flash[:error] = @event.errors.full_messages.to_sentence
      render 'new'
    end
  end  

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params.require(:event).permit(:name, :venue, :category, 
      :starts_at, :ends_at, :hero_image_url, :extended_html_description)
  end
end

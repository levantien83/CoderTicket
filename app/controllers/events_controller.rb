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
  before_action :set_event, only: [:check_owner, :show, :edit, :update, :publish_now, :unpublish]
  before_action :check_owner, only: [:edit, :update, :publish_now, :unpublish]

  def index    
    @events = Event.upcoming.published.search(params[:search]).order('starts_at asc')
  end

  def my_events
    @events = current_user.events.order('created_at desc')
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
    if @event.save
      flash[:notice] = 'Event created'
      redirect_to @event
    else
      flash[:error] = @event.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show    
  end

  def edit
    @categories = Category.all
    @venues = Venue.all
  end

  def update
    if @event.update(event_params)
      flash[:notice] = 'Event was successfully updated.'
      redirect_to @event
    else
      flash[:error] = @event.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def publish_now    
    @event.published_at = Time.now
    @event.save!
    redirect_to @event
  end

  def unpublish    
    @event.published_at = nil
    @event.save!
    redirect_to @event
  end

  private
  def set_event
      @event = Event.find(params[:id] || params[:event_id])
  end

  def check_owner
    if current_user != @event.user
      flash[:alert] = 'You have no permission'
      redirect_to root_path
    end
  end

  def event_params
    params.require(:event).permit(:name, :venue_id, :category_id, 
      :starts_at, :ends_at, :hero_image_url, :extended_html_description)
  end
end

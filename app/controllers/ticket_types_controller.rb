class TicketTypesController < ApplicationController
  before_action :set_ticket_type, only: [:show, :edit, :update, :destroy]
  before_action :set_event, only: [:new, :create, :show, :edit, :update, :destroy]

  def index
    @ticket_types = TicketType.all
  end

  def new
    @ticket_type = TicketType.new
  end

  def create
    @ticket_type = @event.ticket_types.new(ticket_type_params) 
    @ticket_type.price ||= 100000   
    if @ticket_type.save
      flash[:success] = "New ticket type added"
      redirect_to @event
    else
      flash[:error] = @ticket_type.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def update
    if @ticket_type.update(ticket_type_params)
    flash[:success] = "Ticket type was successfully updated"
    redirect_to @event
    else
      flash[:error] = @ticket_type.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def destroy
    if @event.user_id != current_user.id
      flash[:error] = "Event owner's priority"
      redirect_to root_path    
    else
      @ticket_type.destroy
      flash[:success] = "Ticket type removed!"
      redirect_to @event
    end
  end

  private    
    def set_ticket_type
      @ticket_type = TicketType.find(params[:id])
    end

    def set_event
      @event = Event.find(params[:event_id])
    end

    def ticket_type_params
      params.require(:ticket_type).permit(:name, :price, :max_quantity)
    end
end

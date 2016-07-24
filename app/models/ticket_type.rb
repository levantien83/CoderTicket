# create_table "ticket_types", force: :cascade do |t|
#     t.integer  "event_id"
#     t.integer  "price"
#     t.string   "name"
#     t.integer  "max_quantity"
#     t.datetime "created_at",   null: false
#     t.datetime "updated_at",   null: false
#   end

class TicketType < ActiveRecord::Base
  belongs_to :event

  validates_presence_of :name, :max_quantity
  validates_uniqueness_of :name
end

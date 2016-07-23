# create_table "events", force: :cascade do |t|
#     t.datetime "starts_at"
#     t.datetime "ends_at"
#     t.integer  "venue_id"
#     t.string   "hero_image_url"
#     t.text     "extended_html_description"
#     t.integer  "category_id"
#     t.string   "name"
#     t.datetime "created_at",                null: false
#     t.datetime "updated_at",                null: false
#   end

class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :category
  has_many :ticket_types

  validates_presence_of :name, :venue, :category, :starts_at
  validates_uniqueness_of :name, uniqueness: {scope: [:venue, :starts_at]}

  scope :upcoming, -> { where("starts_at > ?", Time.now) }

  def self.search(search)
    if search
      where(["lower(name) ILIKE ?" , "%#{search.downcase}%"])
    else
      all
    end
  end
end

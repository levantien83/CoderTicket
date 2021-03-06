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
#     t.integer  "user_id"
#     t.datetime "published_at"
#   end

class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :category
  belongs_to :user
  has_many :ticket_types, dependent: :destroy

  validates_presence_of :name, :venue, :category, :starts_at
  validates_uniqueness_of :name, uniqueness: {scope: [:venue, :starts_at]}

  scope :upcoming, -> { where("starts_at > ?", Time.now) }
  scope :published, -> { where('user_id IS ? OR published_at IS NOT ?', nil, nil) }

  def self.search(search)
    if search
      where(["lower(name) ILIKE ?" , "%#{search.downcase}%"])
    else
      all
    end
  end    
end

class Venue < ActiveRecord::Base
  belongs_to :region
  validates_presence_of :name, :full_address
  validates_uniqueness_of :name
end

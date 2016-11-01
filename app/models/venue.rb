class Venue < ApplicationRecord
  # Validation
  validates :name, :description, :latitude, :longitude, :presence => true

  # Define category's Enum
  enum category: {
    bar: 1,
    restaurant: 2,
    coworking_space: 3
  }
end

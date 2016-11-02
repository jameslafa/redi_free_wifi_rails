json.extract! venue, :id, :name, :description, :category, :address, :latitude, :longitude, :created_at, :updated_at
json.url venue_url(venue, format: :json)

json.extract! venue, :id, :rows, :columns, :created_at, :updated_at
json.url venue_url(venue, format: :json)

row_values = 10.upto(20).to_a
column_values = 20.upto(50).to_a

10.times do
  venue = Venue.create rows: row_values.sample, columns: column_values.sample
  1.upto(venue.columns / 3).each do |n|
    (venue.seats.count / 100).times do
      venue.free_sample_seat_group size: n
    end
  end
end
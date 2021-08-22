class Venue < ApplicationRecord
	has_many :seats, dependent: :destroy
	validates :rows, presence: true, numericality: { greater_than: 0 }
	validates :columns, presence: true, numericality: { greater_than: 0 }
	after_create :populate_seats!

	# output is 0-indexed, inputs are 1-indexed
	def seat_index(row, column)
		(row - 1) * columns + (column - 1)
	end

	private

	def populate_seats!
		seat_attributes = []
		1.upto(rows).each do |row|
			1.upto(columns).each do |column|
				seat_attributes << { venue_id: id, row: row, column: column, available: false }
			end
		end
		Seat.insert_all! seat_attributes
	end
end

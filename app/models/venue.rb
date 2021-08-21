class Venue < ApplicationRecord
	has_many :seats, dependent: :destroy
	validates :rows, presence: true, numericality: { greater_than: 0, less_than: 53 }
	validates :columns, presence: true, numericality: { greater_than: 0, less_than: 53 }
	after_create :populate_seats!

	private

	def populate_seats!
		1.upto(rows).each do |row|
			1.upto(columns).each do |column|
				seats.create! row: row, column: column, available: false
			end
		end
	end
end

module VenuesHelper
	def solution_input_json(venue)
		data = {}
		data[:venue] = {}
		data[:venue][:layout] = { rows: venue.rows, columns: venue.columns }
		data[:seats] = {}
		venue.seats.each do |seat|
			data[:seats][seat.name] = { id: seat.id, row: seat.row_letter.downcase, column: seat.column, status: seat.status }
		end
		data.to_json
	end
end

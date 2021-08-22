# frozen_string_literal: true

module VenuesHelper
  def solution_input_json(venue)
    data = {}
    data[:venue] = {}
    data[:venue][:layout] = { rows: venue.rows, columns: venue.columns }
    data[:seats] = {}
    venue.seats.each do |seat|
      data[:seats][seat.name] =
        { id: seat.name, row: seat.row_letter.downcase, column: seat.column, status: seat.status }
    end
    data.to_json
  end

  def percentage_available_seats(venue)
    percentage = 100 * venue.seats.available.count / venue.seats.count.to_f
    '%.2f%%'.format percentage
  end
end

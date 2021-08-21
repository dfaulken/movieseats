class MovieSeatsSolver

	AVAILABLE_STATUS = 'AVAILABLE'.freeze
	ROW_LETTERS = %[a b c d e f g h i j k l m n o p q r s t u v w x y x].freeze

	attr_accessor :input_data
	attr_accessor :requested_group_size
	attr_accessor :venue
	attr_accessor :seat_groups
	attr_accessor :best_group

	def parse_input_data!
		venue = Venue.new
		layout = input_data.fetch('venue').fetch('layout')
		venue.rows = layout.fetch('rows')
		venue.columns = layout.fetch('columns')
		self.venue = venue
		
		seat_groups = []
		seats_data = input_data.fetch('seats').values
		seats_data.each do |seat_data|
			if seat_data.fetch('status') == AVAILABLE_STATUS
				seat = Seat.new
				seat.row = row_number seat_data.fetch('row')
				seat.column = seat_data.fetch 'column'
				seat.id = seat_data.fetch 'id'
				# Is this seat part of a group?
				last_group = seat_groups.last
				last_seat = last_group&.last
				if seat.next_to? last_seat
					last_group << seat
				else seat_groups << [seat]
				end
			end
		end
		self.seat_groups = seat_groups
	end

	def solution_json_data
		return {} unless best_group
		input_data['seats'].slice *(best_group.map(&:id))
	end

	def solve!
		# Mapping larger groups to all sub-groups of requested size
		# (and discarding groups of insufficient size)
		# could be done as part of the first iteration.
		# This is a refactor target if more efficiency is needed.
		requested_size_groups = []
		seat_groups.each do |group|
			if group.size == requested_group_size
				requested_size_groups << group
			elsif group.size > requested_group_size
				subgroup_count = group.size - requested_group_size
				(0...subgroup_count).each do |subgroup_starting_index|
					requested_size_groups << group.slice(subgroup_starting_index, requested_group_size)
				end
			end
		end

		self.best_group = requested_size_groups.sort_by do |group|
			group_row = group.first.row
			group_average_column = Rational(group.sum(&:column), group.size) # avoid floating point issues
			venue.distance_to_front_and_center_from group_row, group_average_column
		end.first || []
	end

	def row_number(row_code)
		letter = row_code.first
		base_index = ROW_LETTERS.index(letter) + 1
		extra_length = row_code.length - 1
		extra_length * 26 + base_index
	end

	class Venue
		attr_accessor :rows
		attr_accessor :columns

		def center_column_number
			Rational(columns, 2) # e.g. 11 columns -> center column number is (11/2) = 5.5
		end

		def distance_to_front_and_center_from(row, column)
			forward_distance = row - 1 # front row is always 1
			side_distance = column - center_column_number
			Math.sqrt(forward_distance.abs2 + side_distance.abs2) # Thanks, Pythagoras
		end
	end

	class Seat
		attr_accessor :row
		attr_accessor :column
		attr_accessor :id

		def next_to?(other_seat)
			return false unless other_seat.is_a? Seat
			return false unless other_seat.row == row
			return false unless (other_seat.column - column).abs == 1
			return true
		end
	end
end
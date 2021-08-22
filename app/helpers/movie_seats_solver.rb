# frozen_string_literal: true

class MovieSeatsSolver
  AVAILABLE_STATUS = 'AVAILABLE'
  ROW_LETTERS = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z].freeze

  attr_accessor :input_data, :requested_group_size, :venue, :seat_groups, :best_group

  def parse_venue(venue_data)
    venue = Venue.new
    layout = venue_data.fetch('layout')
    venue.rows = layout.fetch('rows')
    venue.columns = layout.fetch('columns')
    venue
  end

  def parse_seat(seat_data)
    seat = Seat.new
    seat.row = row_number seat_data.fetch('row')
    seat.column = seat_data.fetch 'column'
    seat.id = seat_data.fetch 'id'
    seat
  end

  def parse_input_data!
    self.venue = parse_venue(input_data.fetch('venue'))

    self.seat_groups = []
    input_data.fetch('seats').each_value do |seat_data|
      next unless seat_data.fetch('status') == AVAILABLE_STATUS

      seat = parse_seat(seat_data)
      # Is this seat part of a group?
      if seat.next_to? seat_groups.last&.last
        seat_groups.last << seat
      else seat_groups << [seat]
      end
    end
  end

  def solution_json_data
    return {} unless best_group

    input_data['seats'].slice(*best_group.map(&:id))
  end

  def requested_size_subgroups(group)
    return [group] if group.size == requested_group_size

    subgroup_count = group.size - requested_group_size
    (0...subgroup_count).map do |subgroup_starting_index|
      group.slice(subgroup_starting_index, requested_group_size)
    end
  end

  def size_seat_groups!
    # Mapping larger groups to all sub-groups of requested size
    # (and discarding groups of insufficient size)
    # could be done as part of the first iteration.
    # This is a refactor target if more efficiency is needed.
    requested_size_groups = []
    seat_groups.each do |group|
      unless group.size < requested_group_size
        requested_size_groups += requested_size_subgroups(group)
      end
    end
    self.seat_groups = requested_size_groups
  end

  def solve!
    size_seat_groups!
    self.best_group = seat_groups.min_by do |group|
      group_row = group.first.row
      group_average_column = Rational(group.sum(&:column), group.size) # avoid floating point issues
      venue.distance_to_front_and_center_from group_row, group_average_column
    end || []
  end

  def row_number(row_code)
    letter = row_code.first
    base_index = ROW_LETTERS.index(letter) + 1
    extra_length = row_code.length - 1
    extra_length * 26 + base_index
  end

  class Venue
    attr_accessor :rows, :columns

    def center_column_number
      Rational(columns + 1, 2) # e.g. 10 columns -> center column number is (11/2) = 5.5
    end

    def distance_to_front_and_center_from(row, column)
      forward_distance = row - 1 # front row is always 1
      side_distance = column - center_column_number
      Math.sqrt(forward_distance.abs2 + side_distance.abs2) # Thanks, Pythagoras
    end
  end

  class Seat
    attr_accessor :row, :column, :id

    def next_to?(other_seat)
      return false unless other_seat.is_a? Seat
      return false unless other_seat.row == row
      return false unless (other_seat.column - column).abs == 1

      return true
    end
  end
end

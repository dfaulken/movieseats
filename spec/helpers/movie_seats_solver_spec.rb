require 'rails_helper'

RSpec.describe MovieSeatsSolver do
  let(:solver) { described_class.new }

  it 'has an available status that is the same as for Seat' do
    expect(MovieSeatsSolver::AVAILABLE_STATUS).to eq Seat::AVAILABLE_STATUS
  end

  it 'has 26 row letters' do
    expect(MovieSeatsSolver::ROW_LETTERS.size).to eq 26
  end

  describe 'parse_input_data!' do
    it 'parses input data format into Venue and Seat objects' do
      solver.input_data = {
        venue: {
          layout: { rows: 2, columns: 3 }
        },
        seats: {
          seat_id1: { id: 'seat_id1', row: 'a', column: 1, status: 'AVAILABLE' },
          seat_id2: { id: 'seat_id2', row: 'a', column: 2, status: 'NOT AVAILABLE' },
          seat_id3: { id: 'seat_id3', row: 'a', column: 3, status: 'NOT AVAILABLE' },
          seat_id4: { id: 'seat_id4', row: 'b', column: 1, status: 'NOT AVAILABLE' },
          seat_id5: { id: 'seat_id5', row: 'b', column: 2, status: 'NOT AVAILABLE' },
          seat_id6: { id: 'seat_id6', row: 'b', column: 3, status: 'NOT AVAILABLE' },
        }
      }.deep_stringify_keys
      expect { solver.parse_input_data! }.not_to raise_error

      venue = solver.venue
      expect(venue).to be_a MovieSeatsSolver::Venue
      expect(venue.rows).to eq 2
      expect(venue.columns).to eq 3

      expect(solver.seat_groups.size).to eq 1
      group = solver.seat_groups.first
      expect(group.size).to eq 1

      seat = group.first
      expect(seat).to be_a MovieSeatsSolver::Seat
      expect(seat.row).to eq 1 # a
      expect(seat.column).to eq 1
      expect(seat.id).to eq 'seat_id1'
    end

    it 'groups available seats together' do
      solver.input_data = {
        venue: {
          layout: { rows: 2, columns: 3 }
        },
        seats: {
          seat_id1: { id: 'seat_id1', row: 'a', column: 1, status: 'AVAILABLE' },
          seat_id2: { id: 'seat_id2', row: 'a', column: 2, status: 'AVAILABLE' },
          seat_id3: { id: 'seat_id3', row: 'a', column: 3, status: 'NOT AVAILABLE' },
          seat_id4: { id: 'seat_id4', row: 'b', column: 1, status: 'NOT AVAILABLE' },
          seat_id5: { id: 'seat_id5', row: 'b', column: 2, status: 'NOT AVAILABLE' },
          seat_id6: { id: 'seat_id6', row: 'b', column: 3, status: 'NOT AVAILABLE' },
        }
      }.deep_stringify_keys
      solver.parse_input_data!
      expect(solver.seat_groups.count).to eq 1
    end

    it 'does not group seats in different rows together' do
      solver.input_data = {
        venue: {
          layout: { rows: 2, columns: 3 }
        },
        seats: {
          seat_id1: { id: 'seat_id1', row: 'a', column: 1, status: 'NOT AVAILABLE' },
          seat_id2: { id: 'seat_id2', row: 'a', column: 2, status: 'NOT AVAILABLE' },
          seat_id3: { id: 'seat_id3', row: 'a', column: 3, status: 'AVAILABLE' },
          seat_id4: { id: 'seat_id4', row: 'b', column: 1, status: 'AVAILABLE' },
          seat_id5: { id: 'seat_id5', row: 'b', column: 2, status: 'NOT AVAILABLE' },
          seat_id6: { id: 'seat_id6', row: 'b', column: 3, status: 'NOT AVAILABLE' },
        }
      }.deep_stringify_keys
      solver.parse_input_data!
      expect(solver.seat_groups.count).to eq 2
    end
  end

  describe 'solution_json_data' do
    context 'solve has happened' do
      it 'returns the input data for the seats in the solution' do
        seat1 = MovieSeatsSolver::Seat.new
        seat1.row = 3
        seat1.column = 18
        seat1.id = 'seat1_id'

        seat2 = MovieSeatsSolver::Seat.new
        seat2.row = 3
        seat2.column = 19
        seat2.id = 'seat2_id'

        solver.best_group = [seat1, seat2]
        solver.input_data = {
          seats: {
            seat1_id: { seat1_data: true },
            seat2_id: { seat2_data: true }
          }
        }.deep_stringify_keys

        result = solver.solution_json_data
        expect(result).to be_a Hash
        expect(result).to have_key seat1.id
        expect(result[seat1.id]).to eq({ 'seat1_data' => true })
        expect(result[seat2.id]).to eq({ 'seat2_data' => true })
      end
    end
    context 'solve has not happened' do
      it 'returns an empty hash' do
        expect(solver.solution_json_data).to eq Hash.new
      end
    end
  end

  describe 'solve!' do
    before do
      venue = MovieSeatsSolver::Venue.new
      venue.rows = 3
      venue.columns = 5
      solver.venue = venue
    end

    context 'requested group size is 1' do
      before do
        solver.requested_group_size = 1
      end

      it 'finds the seat that is closest to the front, all other things being equal' do
        seat1 = MovieSeatsSolver::Seat.new
        seat1.row = 1
        seat1.column = 2

        seat2 = MovieSeatsSolver::Seat.new
        seat2.row = 2
        seat2.column = 2

        seat3 = MovieSeatsSolver::Seat.new
        seat3.row = 3
        seat3.column = 2

        solver.seat_groups = [[seat1], [seat2], [seat3]]

        expect { solver.solve! }.not_to raise_error

        expect(solver.best_group).to eql [seat1]
      end

      it 'finds the seat that is closest to the center, all other things being equal' do
        seat1 = MovieSeatsSolver::Seat.new
        seat1.row = 2
        seat1.column = 2

        seat2 = MovieSeatsSolver::Seat.new
        seat2.row = 2
        seat2.column = 3

        seat3 = MovieSeatsSolver::Seat.new
        seat3.row = 2
        seat3.column = 4

        solver.seat_groups = [[seat1], [seat2], [seat3]]

        expect { solver.solve! }.not_to raise_error

        expect(solver.best_group).to eql [seat2]
      end
    end
    context 'requested group size is greater than 1' do
      before do
        solver.requested_group_size = 2
      end

      it 'discards groups of closer seats if they are too small' do
        seat1 = MovieSeatsSolver::Seat.new
        seat1.row = 1
        seat1.column = 3

        seat2 = MovieSeatsSolver::Seat.new
        seat2.row = 3
        seat2.column = 1

        seat3 = MovieSeatsSolver::Seat.new
        seat3.row = 3
        seat3.column = 2

        solver.seat_groups = [[seat1], [seat2, seat3]]

        expect { solver.solve! }.not_to raise_error

        expect(solver.best_group).not_to include seat1
      end

      it 'finds the best subgroup of the best group of available seats' do
        seat1 = MovieSeatsSolver::Seat.new
        seat1.row = 3
        seat1.column = 3

        seat2 = MovieSeatsSolver::Seat.new
        seat2.row = 3
        seat2.column = 4

        seat3 = MovieSeatsSolver::Seat.new
        seat3.row = 3
        seat3.column = 5

        solver.seat_groups = [[seat1, seat2, seat3]]

        expect { solver.solve! }.not_to raise_error

        expect(solver.best_group).to eq [seat1, seat2]
      end
    end
  end
end

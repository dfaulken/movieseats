class CreateSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :seats do |t|
      t.integer :venue_id
      t.integer :row
      t.integer :column
      t.boolean :available
    end
  end
end

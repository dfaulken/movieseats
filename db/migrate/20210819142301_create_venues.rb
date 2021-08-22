# frozen_string_literal: true

class CreateVenues < ActiveRecord::Migration[6.1]
  def change
    create_table :venues do |t|
      t.integer :rows
      t.integer :columns

      t.timestamps
    end
  end
end

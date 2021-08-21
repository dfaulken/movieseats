class Seat < ApplicationRecord
	belongs_to :venue
	validates :row, presence: true, numericality: { greater_than: 0, less_than: 53 }
	validates :column, presence: true, numericality: { greater_than: 0, less_than: 53 }
	validates :available, inclusion: { in: [true, false] } # disallow nil

	LETTERS = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z].freeze

	AVAILABLE_STATUS = 'AVAILABLE'.freeze
	NOT_AVAILABLE_STATUS = 'NOT AVAILABLE'.freeze

	default_scope { order :row, :column }
	scope :at, -> (row, column) { where row: row, column: column }

	def name
		"#{row_letter}#{column}"
	end

	def row_letter
		letter = LETTERS[(row % 26) - 1]
		if row <= 26
			letter
		else
			letter * 2
		end
	end

	def status
		if available?
			AVAILABLE_STATUS
		else NOT_AVAILABLE_STATUS
		end
	end
end

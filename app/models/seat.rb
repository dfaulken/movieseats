class Seat < ApplicationRecord
	belongs_to :venue
	validates :row, presence: true, numericality: { greater_than: 0 }
	validates :column, presence: true, numericality: { greater_than: 0 }
	validates :available, inclusion: { in: [true, false] } # disallow nil

	LETTERS = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z].freeze

	AVAILABLE_STATUS = 'AVAILABLE'.freeze
	UNAVAILABLE_STATUS = 'NOT AVAILABLE'.freeze

	default_scope { order :row, :column }

	scope :available, -> { where available: true }
	scope :unavailable, -> { where.not available: true }

	def name
		"#{row_letter}#{column}"
	end

	def row_letter
		count, index = (row - 1 + LETTERS.count).divmod LETTERS.count
		LETTERS[index] * count
	end

	def status
		if available?
			AVAILABLE_STATUS
		else UNAVAILABLE_STATUS
		end
	end
end

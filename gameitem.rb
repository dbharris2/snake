module GameItem
	attr_accessor :x, :y, :color

	def initialize(x, y, color = Rubygame::Color[:white])
		@x = x
		@y = y
		@color = color
	end

	# Static methods
	def self.cell_size
		16
	end
end
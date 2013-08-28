class Snake
	attr_reader :segments, :x, :y
	attr_accessor :dead
	alias_method :dead?, :dead

	class SnakeSegment
		include GameItem
		
		def initialize(x, y, color = Rubygame::Color[:yellow])
			super
		end
	end

	def initialize(x, y)
		@segments = []
		@x, @y = x, y
		@dead = false
		
		changeDirection(:right)
		
		add_element
	end
	
	def add_element
		if @segments.empty?
			segment = SnakeSegment.new(@x, @y)
		else
			segment = SnakeSegment.new(@segments.last.x - @dir_x, @segments.last.y - @dir_y)
		end
		
		@segments << segment
	end
	
	def changeDirection(direction)
		case direction
			when :up
				@dir_x, @dir_y = [0, -1] unless @dir_y == 1
			when :down
				@dir_x, @dir_y = [0, 1] unless @dir_y == -1
			when :left
				@dir_x, @dir_y = [-1, 0] unless @dir_x == 1
			when :right
				@dir_x, @dir_y = [1, 0] unless @dir_x == -1
		end
	end
	
	def first
		@segments.first
	end
	
	def length
		@segments.size
	end
	
	def move	
		new_head = SnakeSegment.new(@x + @dir_x, @y + @dir_y)
		@segments.unshift(new_head)
		
		@segments.pop # Remove tail
		
		@x, @y = new_head.x, new_head.y
	end
end
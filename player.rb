class Player
	def initialize(character = :mario)
		@character = character
		@media_player = MediaPlayer.new
		@snake = Snake.new#(@max_x/2, @max_y/2)
		# snake_head should be a part of the snake class
	end
end
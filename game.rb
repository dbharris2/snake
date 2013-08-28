class Game
	@@Resolution = [640,480]

	def initialize
		@screen = Rubygame::Screen.new(@@Resolution, 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
		@screen.title = 'Snake!'
 
		@queue = Rubygame::EventQueue.new
		@queue.enable_new_style_events
		
		@clock = Rubygame::Clock.new
		@clock.target_framerate = 10
		
		@score = 0
		@paused = false
		@draw_type = :solid_circle
		
		Rubygame::TTF.setup
		point_size = 16
		@font = Rubygame::TTF.new('arial.ttf', point_size)
		
		@snake_head = CustomIcon.new(:mario)
		@high_scores = ScoreKeeper.loadScores		
		
		@media_player = MediaPlayer.new
		@media_player.playMusic(:mario)		
		@death_sound_played = false
		@music_paused = false
		
		@max_x = @screen.w/GameItem.cell_size
		@max_y = @screen.h/GameItem.cell_size
		
		addBrickBorder
		createSnake
		createFood
		addRandomBricks(20)
	end
	
	def run
		loop do
			update
			draw
			@clock.tick
		end
	end
	
	private
	def addBrickBorder
		@bricks = []
		
		0.upto(@max_x) do |i|
			@bricks << Brick.new(i, 0)
			@bricks << Brick.new(i, @max_y-1)
		end
		
		0.upto(@max_y) do |i|
			@bricks << Brick.new(0, i)
			@bricks << Brick.new(@max_x-1, i)
		end
	end
	
	def addRandomBricks(n)
		0.upto(n) do |i|
			x, y = rand(@max_x), rand(@max_y)
			
			unless collisionAt?(x, y, @snake) or collisionAt?(x, y, @food)
				@bricks << Brick.new(x, y)
			end
		end
	end
	
	def ate_food?
		collisionAt?(@food.x, @food.y, @snake)
	end
	
	def crashedIntoBrick?
		collision?(@snake.x, @snake.y, @bricks)
	end
	
	def crashedIntoSnake?
		collision?(@snake.x, @snake.y, @snake.segments[1..-1])
	end
	
	def collision?(x, y, items)
		return false if (items.nil? or items.empty?)		
		items.any? { |item| collisionAt?(x, y, item) }
	end
	
	def collisionAt?(x, y, item)
		item.x == x and item.y == y
	end
	
	def createFood
		begin
			@food = Food.new(rand(@max_x), rand(@max_y)) 
		end while collision?(@food.x, @food.y, @snake.segments) or collision?(@food.x, @food.y, @bricks)
	end
	
	def createSnake
		@snake = Snake.new(@max_x/2, @max_y/2)
	end
 
	def draw
		@screen.fill(:black)
	
		drawBricks
		drawFood
		drawScore
		
		@snake.move unless @snake.dead? or @paused
		drawSnake
		
		drawSnakeHead
		
		handleCollisions
		drawGameOverText if @snake.dead?
		drawHighScoreText if (@snake.dead? and @high_scores.highestScore?(@score))
		
		@screen.update
	end
	
	def drawBox(element)
		unless element.nil?
			case @draw_type
				when :rectangle
					@screen.draw_box([element.x * GameItem.cell_size, element.y * GameItem.cell_size], [element.x * GameItem.cell_size + GameItem.cell_size-1, element.y * GameItem.cell_size + GameItem.cell_size-1], element.color)
				when :solid_rectangle
					@screen.draw_box_s([element.x * GameItem.cell_size, element.y * GameItem.cell_size], [element.x * GameItem.cell_size + GameItem.cell_size-1, element.y * GameItem.cell_size + GameItem.cell_size-1], element.color)
				when :circle
					@screen.draw_circle([element.x * GameItem.cell_size + GameItem.cell_size/2, element.y * GameItem.cell_size + GameItem.cell_size/2], GameItem.cell_size/2, element.color)
				when :solid_circle
					@screen.draw_circle_s([element.x * GameItem.cell_size + GameItem.cell_size/2, element.y * GameItem.cell_size + GameItem.cell_size/2], GameItem.cell_size/2, element.color)
			end
		end
	end
	
	def drawBricks
		@bricks.each do |brick|
			drawBox(brick)
		end
	end
	
	def drawHighScoreText
		text_surface = @font.render_utf8("High Score!", smooth = true, Rubygame::Color[:white])
		rect = text_surface.make_rect
		drawSurfaceRelativeTo(text_surface, rect, @screen.w/2 - rect.width/2,  @screen.h/2 - rect.height - 2 * GameItem.cell_size)
	end
	
	def drawScore
		text_surface = @font.render_utf8("Score: #{@score}", smooth = true, Rubygame::Color[:white])
		rect = text_surface.make_rect
		drawSurfaceRelativeTo(text_surface, rect, @screen.w - 20 - rect.width,  20)
	end
	
	def drawGameOverText
		text_surface = @font.render_utf8("Game over!", smooth = true, Rubygame::Color[:white])
		rect = text_surface.make_rect
		drawSurfaceRelativeTo(text_surface, rect, @screen.w/2 - rect.width/2,  @screen.h/2 - rect.height/2)
	end
	
	def drawFood		
		food_icon = CustomIcon.new(:apple)
		drawSurfaceAt(food_icon.image, @food.x * GameItem.cell_size, @food.y * GameItem.cell_size)
	end
	
	def drawSurfaceAt(surface, topleft_x, topleft_y)
		rect = surface.make_rect
		drawSurfaceRelativeTo(surface, rect, topleft_x, topleft_y)
	end
	
	def drawSurfaceRelativeTo(surface, rect, topleft_x, topleft_y)
		rect.topleft = [topleft_x, topleft_y]
		surface.blit(@screen, rect)
	end
	
	def drawSnake
		@snake.segments.each do |segment|
			drawBox(segment) unless segment == @snake.first
		end
	end
	
	def drawSnakeHead
		drawSurfaceAt(@snake_head.image, @snake.x * GameItem.cell_size, @snake.y * GameItem.cell_size)
	end
	
	def handleCollisions
		@snake.dead = (crashedIntoBrick? or crashedIntoSnake?)
		
		if @snake.dead?			
			@media_player.stopMusic
			@media_player.playSound(:death) unless @death_sound_played
			@death_sound_played = true
		elsif ate_food?
			@media_player.playSound(:ring)
			@snake.add_element
			@score += 10
			createFood
		end
	end
	
	def handleScores
		@high_scores = ScoreKeeper.loadScores
		@high_scores << @score
		@high_scores.writeScores
	end
	
	def update
		@queue.each do |ev|
			case ev
				when Rubygame::QuitEvent
					Rubygame.quit
					exit
				when Rubygame::Events::KeyPressed
					case ev.key
						when :q
							handleScores if @snake.dead?
							Rubygame.quit
							exit
						when :p
							@paused = !@paused
							@media_player.playSound(:pause) if @paused
						when :s
							if @draw_type == :circle
								@draw_type = :solid_circle
							elsif @draw_type == :solid_circle
								@draw_type = :circle
							elsif @draw_type == :solid_rectangle
								@draw_type = :rectangle
							else
								@draw_type = :solid_rectangle
							end
						when :c
							if @draw_type == :rectangle
								@draw_type = :circle
							elsif @draw_type == :circle
								@draw_type = :rectangle
							elsif @draw_type == :solid_circle
								@draw_type = :solid_rectangle
							else
								@draw_type = :solid_circle
							end
						when :l
							@snake_head = CustomIcon.new
						when :m
							@media_player.paused? ? @media_player.unpauseMusic : @media_player.pauseMusic
							@music_paused = @media_player.paused?
							
							@media_player.replayMusic if (@media_player.stoppedMusic? and !@music_paused)
						when :r
							if @snake.dead?					
								addBrickBorder
								createSnake
								createFood
								addRandomBricks(20)
								
								handleScores
								@score = 0
								
								@media_player.replayMusic unless @music_paused
								@death_sound_played = false
							end
						when :up, :down, :left, :right
							@snake.changeDirection(ev.key)
					end
			end
		end
	end
end
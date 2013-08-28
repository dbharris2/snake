class CustomIcon
	include Rubygame::Sprites::Sprite
	
	attr_reader :image
	
	def initialize(icon = :random)
		super()
		
		@icons = ['sonic.png', 'mario.gif', 'apple.png']
		
		case icon
			when :apple
				@filename = 'apple.png'
			when :sonic
				@filename = 'sonic.png'
			when :mario
				@filename = 'mario.gif'
			else
				@filename = randomIcon
		end
		
		@image = loadIcon(@filename)
	end
	
	private
	def randomIcon
		@filename = @icons[rand(@icons.size)]
	end
	
	def loadIcon(icon_filename)
		Rubygame::Surface.load(icon_filename)
	end
end
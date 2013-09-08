class CustomIcon
	include Rubygame::Sprites::Sprite
	
	attr_reader :image
	
	def initialize(icon = :random)
		super()
		
		@icons = ['sonic.png', 'mario.gif', 'mario_coin.png', 'sonic_ring.png']
		
		case icon
			when :sonic
				@filename = 'sonic.png'
			when :sonic_ring
				@filename = 'sonic_ring.png'
			when :mario
				@filename = 'mario.gif'
			when :mario_coin
				@filename = 'mario_coin.png'
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
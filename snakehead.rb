class CustomIcon
	include Rubygame::Sprites::Sprite
	
	attr_reader :image
	
	def initialize
		super
		
		@heads = ['alien.gif', 'chrome.png', 'facebook.png', 'mac.gif', 'sonic.jpg', 'ubuntu.png', 'windows.png']
		
		@filename = randomIcon
	end
	
	def randomIcon
		begin
			icon_filename = @heads[rand(@heads.size)]
		end while icon_filename == @filename
		
		@filename = icon_filename
		@image = Rubygame::Surface.load(@filename)
	end
end
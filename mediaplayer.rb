class MediaPlayer
	def initialize
		this_dir = File.dirname( File.expand_path(__FILE__) )
		
		Rubygame::Sound.autoload_dirs << File.join(this_dir, 'sfx')
		Rubygame::Music.autoload_dirs << File.join(this_dir, 'music')
		
		loadMusic
		loadSounds
	end
	
	def paused?
		@curr_music.paused? unless @curr_music.nil?
	end
	
	def pauseMusic
		@curr_music.pause unless @curr_music.nil?
	end
	
	def playMusic(who)
		case who
			when :sonic
				@curr_music = @sonic_music.play(:repeats => -1)
			when :mario
				@curr_music = @mario_music.play(:repeats => -1)
		end
	end
	
	def playSound(who, what)		
		case who
			when :mario
				@mario_sounds[what].play
			when :sonic
				@sonic_sounds[what].play
		end
	end
	
	def replayMusic
		@curr_music.play(:repeats => -1) unless @curr_music.nil?
	end
	
	def stopMusic
		@curr_music.stop unless @curr_music.nil?
	end
	
	def stoppedMusic?
		@curr_music.stopped? unless @curr_music.nil?
	end
	
	def unpauseMusic
		@curr_music.unpause unless @curr_music.nil?
	end
	
	private
	def loadMusic
		@contra_music = Rubygame::Music['contra_jungle.mp3']
		@sonic_music = Rubygame::Music['sonic.mp3']
		@mario_music = Rubygame::Music['mario_music.mp3']
	end
	
	def loadSounds
		@sonic_eat = Rubygame::Sound['sonic_ring.wav']
		@sonic_death = Rubygame::Sound['sonic_death.wav']
		@sonic_pause = Rubygame::Sound['sonic_pause.wav']
		
		@sonic_sounds = {}
		@sonic_sounds[:eat] = @sonic_eat
		@sonic_sounds[:pause] = @sonic_pause
		@sonic_sounds[:death] = @sonic_death
		
		@mario_coin = Rubygame::Sound['mario_coin.wav']
		@mario_death = Rubygame::Sound['mario_death.wav']
		@mario_pause = Rubygame::Sound['mario_pause.wav']
		
		@mario_sounds = {}
		@mario_sounds[:eat] = @mario_coin
		@mario_sounds[:pause] = @mario_pause
		@mario_sounds[:death] = @mario_death
	end
end
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
	
	def playMusic(music)
		case music
			when :sonic
				@curr_music = @sonic_music.play(:repeats => -1)
			when :contra
				@curr_music = @contra_music.play(:repeats => -1)
			when :mario
				@curr_music = @mario_music.play(:repeats => -1)
		end
	end
	
	def playSound(sound)
		case sound
			when :ring
				@mario_coin.play
			when :death
				@mario_death.play
			when :pause
				@mario_pause.play
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
		@ring_sound = Rubygame::Sound['sonic_ring.wav']
		@death_sound = Rubygame::Sound['death.wav']
		
		@mario_coin = Rubygame::Sound['mario_coin.wav']
		@mario_death = Rubygame::Sound['mario_death.wav']
		@mario_pause = Rubygame::Sound['mario_pause.wav']
	end
end
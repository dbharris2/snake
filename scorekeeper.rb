class ScoreKeeper < Array
	@@Filename = './highscores.txt'
	
	def self.loadScores
		scores = ScoreKeeper.new
		
		if File.exist?(@@Filename)
			File.read(@@Filename).each_line do |score|
				scores << score.chomp.to_i
			end
		else
			File.open(@@Filename, 'w') do |f|
				f.write('')
			end
		end
		
		scores
	end
	
	def add(score)
		push(score)
		self.sort!.reverse!
	end
	
	alias_method :<<, :add
	
	def highestScore?(score)
		self.nil? or self.empty? or score > self.first
	end
	
	def writeScores		
		File.open(@@Filename, 'w') do |f|
			num_scores = self.size >= 10 ? 10 : self.size
			f.write(self[0...num_scores].join("\n"))
		end
	end

end
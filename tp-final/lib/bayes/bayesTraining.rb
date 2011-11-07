module Bayes
	class BayesTraining
	attr_accessor :emails, :palabras, :wordsSpam, :wordsNoSpam  

	def initialize(emails,spam)
		@emails = emails
		@spam = spam
		@wordsSpam = initializeWordsN
		@wordsNoSpam = initializeWords
		calculateProbability
		changeProbability
	end

	def initializeWords
	 words = []
	 @emails.each do |email|
	 	email.each do |word|
	 	 words <<{ :word=> word, :occurrence => 0.0, :probability => 0.0}
	 	end
	 end
	 words.uniq!
	end

	def initializeWordsN
	 words = []
	 @spam.each do |email|
	 	email.each do |word|
		 words << { :word=> word, :occurrence => 0.0,:probability => 0.0}
	 	end
	 end
	 words.uniq!
	end

	def calculateProbability
		@emails.each do |email|
			email.each do |word|
			 ocurrCant = occurrenceAmount(@emails,word)
			 changeOccurrence(ocurrCant,@wordsNoSpam,word)
			end
		end

		@spam.each do |email|
			email.each do |word|
			 ocurrCant = occurrenceAmount(@spam,word)
			 changeOccurrence(ocurrCant,@wordsSpam,word)
			end
		end
	end
	
	def occurrenceAmount(emails,word)
	  cant = 0
		emails.each do |mail|
			mail.each do |word1|
			cant +=1 if(word == word1)
		  end
		end
		cant
	end

	def changeOccurrence(cant,words,word)
		words.each_index do |i|
			if(words[i][:word] == word)
			words[i][:occurrence] = cant
		  end
		end
	end

	def changeProbability
		size_spam   = (@spam.count).to_f
		size_emails = (@emails.count).to_f
		@wordsNoSpam.each do |word|
			occSpam = findOcurrence(word,@wordsSpam)
			word[:probability] = (word[:occurrence] /size_emails) / ((occSpam/size_spam)+(word[:occurrence] /size_emails))
		end
		@wordsSpam.each do |word|
			occNoSpam = findOcurrence(word,@wordsNoSpam)
			word[:probability] = (word[:occurrence] /size_spam) / ((occNoSpam/size_emails)+(word[:occurrence] /size_spam))
		end
	end

	def findOcurrence(word,words)
		words.each do |word1|
			if(word1 == word)
				return word1[:occurrence]
			end
		end
		0.0
	end
	
	
	
	end
end

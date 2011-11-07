module Bayes
	class BayesSpam
	attr_accessor :email, :classBayesTraining, :floorProbability	 

	def initialize(email,classBayesTraining)
		@floorProbability = 0.3
		@classBayesTraining = classBayesTraining #datos de las palabras almacenados en el entrenamiento
		@email = intitializeMail(email)
		setProbability
		probability
	end
	
	
	def intitializeMail(email)
		e_mail=[]
		email.each do |word|
			e_mail << {:word => word, :spamProbability => 0.0, :probability => 0.0}
		end
		e_mail
	end

	def setProbability
		@email.each do |word|
			word[:probability] = findProbability(word[:word],true)
			word[:spamProbability] = findProbability(word[:word],false)
		end
	end

	def findProbability(word,bool)
		if(bool==true)
	  wordsNoSpam = @classBayesTraining.wordsNoSpam
		wordsNoSpam.each do |word1|
			if(word1[:word] == word)
				return word1[:probability]
			end
		end
		else
		wordsSpam = @classBayesTraining.wordsSpam
		wordsSpam.each do |word1|
			if(word1[:word] == word)
				return word1[:probability]
			end
		end
		end
		#si no esta le asignamos la probabilidad de piso
    @floorProbability
	end

	def extractMoreSignificant
		#podriamos extraer las palabras que tienen mas significacion 
	end


	def probability
		pSpam = 0.0 #probabilidad de spam
		pNSpam = 0.0 
		@email.each {|word| pSpam+=Math.log(word[:spamProbability]); pNSpam+=(Math.log(word[:probability])) }
		p "la probabilidad de spam es"
		p pSpam / (pSpam + pNSpam)
	end

	end
end

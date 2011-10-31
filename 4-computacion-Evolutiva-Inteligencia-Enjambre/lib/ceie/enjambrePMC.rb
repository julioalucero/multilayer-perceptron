module Ceie
  class EnjambrePMC
	
		attr_accessor :cantidad, :particulas, :epocas  
		attr_accessor :bestPosGlobal, :entradas, :capas 

		#capas es asi [4,3,2] osea 3 capas , con 4, 3 y 2 neuronas respectivamente
	def initialize(cantidad,dimension,epocas,funcion,entradas,capas)
		@cantidad = cantidad
		@epocas = epocas
		@bestPosGlobal = Array.new(dimension,0.0)
		@entradas = entradas
		@capas = capas
		@particulas = initializeProblem
	end

	def initializeProblem
		particulas = []		
	  @cantidad.times do
		 particulas << {:pos => [[initRandx,initRandy]], :vel =>[[initRandx,initRandy]], :fitness => [], :bestpos => [0.0,0.0] }
		end
		particulas.each do |particula|
			particula[:fitness] << calculateFitness(particula[:pos][0])
			particula[:bestpos] = particula[:pos][0]
			@bestPosGlobal = particula[:pos][0] if(particula[:fitness][0] < calculateFitness(@bestPosGlobal))
		end
		particulas
	end

	def initRandx
		rand(@rangox[1])-rand(@rangox[0])
	end

	def initRandy
		rand(@rangoy[1])-rand(@rangoy[0])
	end
	
	def resolver
	  c1 = 2.0
		c2 = 2.0
		tiempo = 1
		while(tiempo < @epocas)   #condicion de corte
			@particulas.each do |particula|
				particula[:vel]     << actualizarVel(particula,c1,c2,tiempo)
				particula[:pos]     << actualizarPos(particula,tiempo)
		  	particula[:fitness] << actualizarFitness(particula,tiempo)
				replaceBestPos(particula)
			end
		tiempo +=1
	  graficarSolucion if (tiempo % 100 == 0)
		end
	end

	def actualizarVel(particula,c1,c2,tiempo)
		aux1 = particula[:vel][tiempo-1][0] 
		aux2 = c1 *rand * (particula[:bestpos][0]- particula[:pos][tiempo-1][0])*tiempo 
		aux3 = c2 *rand *  (@bestPosGlobal[0] - particula[:pos][tiempo-1][0])
		auy1 = particula[:vel][tiempo-1][1] 
		auy2 = c1 *rand * (particula[:bestpos][1]- particula[:pos][tiempo-1][1])*tiempo 
		auy3 = c2 *rand *  (@bestPosGlobal[1] - particula[:pos][tiempo-1][1])
		[aux1+aux2+aux3, auy1+auy2+auy3]
	end

	def actualizarPos(particula,tiempo)
	 aux = particula[:pos][tiempo-1][0] + particula[:vel][tiempo][0]
	 auy = particula[:pos][tiempo-1][0] + particula[:vel][tiempo][1]
  end

	def actualizarFitness(particula,tiempo)
		calculateFitness(particula[:pos][tiempo])
	end

	def replaceBestPos(particula)
		if(particula[:fitness].last < calculateFitness(particula[:bestpos]))
			particula[:bestpos] = particula[:pos].last
		end
		if(particula[:fitness].last < calculateFitness(@bestPosGlobal))
			@bestPosGlobal = particula[:pos].last
		end
	end
	

	#Perceptron

   def forwardPropagation(particula)
	 	 contador = @entradas.count
		 @entradas.each_index do |i|	
     	entradaAux = @entradas[i].clone
     	entradaAux.delete(entradaAux.last) # Se elimina la última xq es la deseada
     	y = Array.new
       @capas.each do
			 y = calculateOutput(entradaAux)
       entradaAux=y
     	end
     	@error << (((@entradas[q].last-y.first)**2)/2.0)
   
	 	end
	 end

    def calculateOutput(particula,entradas,capa)
      y  = Array.new
      for i in 0..(@capas[capa]-1)
        sum = 0
        for k in 0..(@entradas.length-1)
          pos = mapearPos(i,k,capa)
					sum = sum + particula[:pos][pos] * @entradas[k]
        end
        sum = sigmoide(sum+@umbral[i], 30)
        y << sum
      end
      y
    end

    def sigmoide(y,a)
       y =  1.0/(1.0 +  Math.exp(-a*y))
    end

		def mapearPos(i,j,capa)	
		
		end
end
end

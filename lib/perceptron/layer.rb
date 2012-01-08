module Perceptron
  class Layer
    attr_accessor :numNeuronas,:numeEntradas, :matrixWeights, :salidas, :entradas, :umbral, :deltas, :matrixMomentum, :vectorUmbral

    #  matrixWeights va a contener los pesos de cada neurona.
    #  Las filas corresponden a cada neurona.
    #  Por cada columna tenemos los pesos para esa neurona.
    #  Ej.
    #  [  w11   ,    w12  ,   w13  ]  # Neurona 1
    #  [  w12   ,    w22  ,   w23  ]  # Neurona 2
    #  matrixMomentum guarda los deltaW para calcularlos con la formula de momento, al igual que vectorUmbral

    def initialize(numNeuronas,numEntradas)
      @numEntradas = numEntradas
      @numNeuronas = numNeuronas
      initializeWeights
      @matrixMomentum = Array.new
      for i in 0..@matrixWeights.length-1
        aux = Array.new
        for j in 0..@matrixWeights[0].length-1
          aux << 0
        end
        @matrixMomentum << aux
      end
      @vectorUmbral = Array.new
       for i in 0..@numNeuronas-1
	       @vectorUmbral[i]=0
       end      
    end

    # Inicializa al azar todos los pesos (w)
    def initializeWeights
      @matrixWeights = Array.new
      @umbral = Array.new
      for i in 0..@numNeuronas-1
        aux = Array.new
        for j in 0..@numEntradas-1
          aux << (2*0.05*rand-0.05)
        end
        @matrixWeights << aux
        @umbral << (2*0.05*rand-0.05)
      end
    end

    # guardamos la entradas
    def guardarEntradas(entradas)
      @entradas = entradas
    end

    #realiza el calculo delta
    def initializeDeltas(deltasCapaSuperior,pesosCapaSuperior)
    	aux=Array.new	
	index = pesosCapaSuperior[0].length
	for j in 0..(index-1)
	sum=0
		for k in 0..(deltasCapaSuperior.length-1)
			sum+= pesosCapaSuperior[k][j]*deltasCapaSuperior[k]
		end
	aux << sum * (@salidas[j]*(1-@salidas[j]))	 
	end
	@deltas = aux    
    end

    # realiza la operacion =>    < W . X > = y
    def calculateOutput(entradas)
      guardarEntradas(entradas)
      y  = Array.new
      for i in 0..(@numNeuronas-1)
        sum = 0
        for k in 0..(@entradas.length-1)
          sum = sum + matrixWeights[i][k] * @entradas[k]
        end
        sum = sigmoide(sum+@umbral[i], 30)
        y << sum
      end
      @salidas = y
    end

    def sigmoide(y,a)
       y =  1.0/(1.0 +  Math.exp(-a*y))
    end

    def dersig(y,a)
       y= 0.5 * (sigmoide(y,a)+1.0) * (sigmoide(y,a)-1.0)
    end

    def updateWeigt(nu)
      for i in 0..(@entradas.length-1)
        for j in 0..(@matrixWeights.length-1)
          @matrixWeights[j][i] = @matrixWeights[j][i] + (nu * @deltas[j] * @entradas[i])
        end
      end 
      for i in 0..(@deltas.length-1)
        @umbral[i] = @umbral[i] + nu*deltas[i]
      end	
    end

    def updateWeigtWithMomentum(nu,alfa)
	for i in 0..(@entradas.length-1)
         for j in 0..(@matrixWeights.length-1)
          @matrixWeights[j][i] = @matrixWeights[j][i] + (nu * @deltas[j] * @entradas[i]) + alfa*@matrixMomentum[j][i]
	  @matrixMomentum[j][i] = nu * @deltas[j] * @entradas[i]          	
	 end
	end 
        for i in 0..(@deltas.length-1)
         @umbral[i] = @umbral[i] + nu*deltas[i] + alfa*@vectorUmbral[i]
	 @vectorUmbral[i]=nu*deltas[i]
        end	
    end
  end
end

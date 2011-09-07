module Perceptron
  class Layer
    attr_accessor :numNeuronas,:numeEntradas, :matrixWeights, :salidas, :entradas

    #  matrixWeights va a contener los pesos de cada neurona.
    #  Las filas corresponden a cada neurona.
    #  Por cada columna tenemos los pesos para esa neurona.
    #  Ej.
    #  [  w11   ,    w12  ,   w13  ]  # Neurona 1
    #  [  w12   ,    w22  ,   w23  ]  # Neurona 2
    def initialize(numNeuronas,numEntradas)
      @numEntradas = numEntradas
      @numNeuronas = numNeuronas
      initializeWeights
    end

    # Inicializa al azar todos los pesos (w)
    def initializeWeights()
      @matrixWeights = Array.new
      for i in 0..@numNeuronas-1
        aux = Array.new
        for j in 0..@numEntradas - 1
          aux << ( 2 * 0.5 - rand * 0.5 )
        end
        @matrixWeights << aux
      end
    end

#    def guardarEntradas(entradas)
#    	@entradas = entradas
#    end
#     
#    	def calculateOuput(entradas)
#    		guardarEntradas(entradas)
#    		y=Array.new
#    		for i in 0..(@numNeuronas-1)
#    			sum=0
#    			for k in 0..(@entradas.length-1)
#    			sum = sum + matrixWeights[i][k]*@entradas[k]
#    			end
#    		#sum=sigmoide(sum - umbral)
#    		y.push(sum) 
#    		end
#    		@salidas = y
#    		y
#    	end

  end
end

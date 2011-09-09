module Perceptron
  class Layer
    attr_accessor :numNeuronas,:numeEntradas, :matrixWeights, :salidas, :entradas, :umbral, :deltas

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
      @umbral = Array.new
      for i in 0..@numNeuronas-1
        aux = Array.new
        for j in 0..@numEntradas - 1
          aux << ( 2 * 0.5 * rand - 0.5 )
        end
        @matrixWeights << aux
        @umbral << 2 * 0.5 * rand - 0.5 
      end
    end

    # guardamos la entradas
    def guardarEntradas(entradas)
      @entradas = entradas
    end

    #realiza el calculo omega = W.omegaCapaSuperior
    def initializeDeltas(deltasCapaSuperior, numNeuronasAnterior)
      y = Array.new
      auxMatrixWeight = @matrixWeights.clone
      auxMatrixWeight = auxMatrixWeight.transpose
      for i in 0..(numNeuronasAnterior-1)
        sum = 0
        for k in 0..(deltasCapaSuperior.length-1)
          sum = sum + auxMatrixWeight[i][k] * deltasCapaSuperior[k]
        end
        y << sum
      end
      @deltas = y
    end


    # realiza la operacion =>    < W . X > = y
    def calculateOutput(entradas)
      guardarEntradas(entradas)
      y  = Array.new
      for i in 0..@numNeuronas-1
        sum = 0
        for k in 0..(@entradas.length-1)
          sum = sum + matrixWeights[i][k] * @entradas[k]
        end
        sum = sigmoide(sum-@umbral[i], 1)
        y << sum
      end
      @salidas = y
      y
    end

    def sigmoide(y,a)
      y= 1 / (1 + Math.exp(-a*y))
    end

    def dersig(y,a)
      y= sigmoide(y,a) * (1-sigmoide(y,a))
    end

    def updateWeigt(deltas,nu)
      for i in 0..(@matrixWeights.length-1)
        for j in 0..(deltas.length-1)
          @matrixWeights[i][j] = @matrixWeights[i][j] + nu * deltas[j] * @entradas[i]
        end
        for i in 0..(deltas.length - 1)
          @umbral[i] -= nu * deltas[i]
        end
      end
    end
  end
end

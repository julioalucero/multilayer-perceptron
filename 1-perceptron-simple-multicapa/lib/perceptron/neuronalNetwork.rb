module Perceptron
  class NeuronalNetwork
    attr_accessor  :capas, :entradas, :numNeuronas, :salidas, :vectorCapas, :indiceEntradas, :delta

    # @capas = numero de capas (contando todas)
    # @entradas = Contiene las entradas principales, vector.Ej. x = [x1, x2, x3, y]
    # @numNeuron = Contiene vector con la cant de neuronas x capa. Ej [3,2,1].
    # @cantIter = Punto de corte, cantidad de entrenamientos.
    # @indiceEntradas = Cantidad de entradas en cada capa. Ej. [2, 3, 2].
    # @vectorCapas =  contiene el array con cada objeto Layer a utilizar
    def initialize(capas, entradas, numNeuronas, iteraciones)
      @capas = capas
      @entradas = entradas
      @numNeuron = numNeuronas
      @cantIter = iteraciones
      @indiceEntradas = initializeIndex
      @vectorCapas = initializeRed
    end

    # recorre cada capa y guarda la cantidad de entradas que posee.
    def initializeIndex
      indiceEntradas = Array.new
      indiceEntradas << @entradas.length - 1 #La ultima entrada es el valor esperado
      for i in 1..@capas-1 do #identificar cual es la capa 0 o la 1
        indiceEntradas << @numNeuron[i-1]
      end
      indiceEntradas
    end

   # Crea los objetos Layer necesarios
   # Ej. [ Layer1, Layer2, Layer3 ]
   def initializeRed
     vectorCapas = Array.new
     for i in 0..@capas - 1
       vectorCapas << Layer.new(@numNeuron[i], @indiceEntradas[i])
     end
     vectorCapas
   end

   def trainingNetwork
     @cantIter.times do
       forwardPropagation
       backPropagation
     #  updateWeights
     end
   end

   #recorrer el vector capas y calcular la salida y guarda las entradas
   def forwardPropagation()
     entradaAux = @entradas.clone
     entradaAux.delete(entradaAux.last) # Se elimina la última xq es la deseada
     y = Array.new
     for i in 0..(@vectorCapas.length-1)
       y = @vectorCapas[i].calculateOutput(entradaAux)
       entradaAux=y
     end
     #error=@entradas(i).last - y
     #calcular el error si se satisface parar...
     @salidas = y
    end

   def backPropagation
     @cantIter += 1
     error = Array.new
     # la idea es recorrer cada capa y calcular su oooomegaaa osea error
     # @entradas es una matriz con todas las entradas,
     # hay q ponerle un indice para llamar a la ultima de la fila
     @delta = [@salidas.first-@entradas.last]
     aux = @capas-1
     error = @delta.clone
     # @vectorCapas[aux].deltas = error
     while aux > 0
       # nota... 
       @vectorCapas[aux].initializeDeltas(error, @vectorCapas[aux-1].numNeuronas)
       error = @vectorCapas[aux].deltas
       aux -= 1
     end
   end
  end
end

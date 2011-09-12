module Perceptron
  class NeuronalNetwork
    attr_accessor  :capas, :entradas, :numNeuronas, :salidas, :vectorCapas, :indiceEntradas, :delta, :nu, :momento

    # @capas = numero de capas (contando todas)
    # @entradas = Contiene las entradas principales, vector.Ej. x = [x1, x2, x3, y]
    # @numNeuron = Contiene vector con la cant de neuronas x capa. Ej [3,2,1].
    # @cantIter = Punto de corte, cantidad de entrenamientos.
    # @indiceEntradas = Cantidad de entradas en cada capa. Ej. [2, 3, 2].
    # @vectorCapas =  contiene el array con cada objeto Layer a utilizar
    def initialize(capas, entradas, numNeuronas, iteraciones, nu, momento)
      @capas = capas
      @entradas = entradas
      @numNeuron = numNeuronas
      @cantIter = iteraciones
      @indiceEntradas = initializeIndex
      @vectorCapas = initializeRed
      @nu = nu
      @momento = momento
      @delta = Array.new
      for i in 0..@numNeuron.last-1
        @delta << 0
      end
    end

    # recorre cada capa y guarda la cantidad de entradas que posee.
    def initializeIndex
      indiceEntradas = Array.new
      indiceEntradas << @entradas[0].length - 1 #La ultima entrada es el valor esperado
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
       for q in 0..(@entradas.length-1)
         forwardPropagation(q)
         backPropagation(q)
         updateWeights(@momento)
       end
     end
   end

   #recorrer el vector capas y calcular la salida y guarda las entradas
   def forwardPropagation(q)
     entradaAux = @entradas[q].clone
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

   def backPropagation(q)
  #   @cantIter += 1
     error = Array.new
     # la idea es recorrer cada capa y calcular su oooomegaaa osea error
     # @entradas es una matriz con todas las entradas,
     # hay q ponerle un indice para llamar a la ultima de la fila

     for i in 0..@numNeuron.last-1
       @delta[i] = (@entradas[q].last - @salidas[i]) * (@salidas[i] * (1.0 - @salidas[i]))
     end

     aux = @capas-1

     error = @delta.clone
     # @vectorCapas[aux].deltas = error
     while aux > 0
       # nota...
       @vectorCapas[aux].initializeDeltas(error, @vectorCapas[aux-1].numNeuronas, @vectorCapas[aux-1].salidas)
       #error = @vectorCapas[aux].deltas
       aux -= 1
     end
   end

    def updateWeights(m)
      #actualizar dps la ultima capa con el delta que se calcula aca
      if m then
        for i in 0..(@capas-2)
          @vectorCapas[i].updateWeigtWithMomentum(@vectorCapas[i+1].deltas, @nu, 0.5)
        end
        @vectorCapas[@capas-1].updateWeigtWithMomentum(@delta, @nu, 0.5)
      else
        for i in 0..(@capas-2)
          @vectorCapas[i].updateWeigt(@vectorCapas[i+1].deltas, @nu)
        end
        @vectorCapas[@capas-1].updateWeigt(@delta, @nu)
      end

    end

    def test(matrix)
      @entradas = matrix
      for q in 0..@entradas.length-1
        forwardPropagation(q)
        p @salidas
     end
    end
  end
end

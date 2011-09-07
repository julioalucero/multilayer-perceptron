module Perceptor
  class NeuronalNetwork
    attr_accessor  :capas, :entradas, :numNeuronas, :salidas, :vectorCapas, :indiceEntradas

     # @capas = capas numero de capas ocultas (contando la de entrada)
     # @entradas = Contiene las entradas principales, vector.Ej. x = [x1, x2, x3, y]
     # @numNeuron = Contiene vector con la cant de neuronas x capa. Ej [3,2].
     # @cantIter = Punto de corte, cantidad de entrenamientos.
     # @indiceEntradas = Cantidad de entradas en cada capa. Ej. [2,1].
     # @vectorCapas = Contiene las neuronas de cada capa.# Ej. [[neuron1, neuron2],[neuron3]]
     def initialize(capas, entradas, numNeuronas, iteraciones)
       @capas = capas
       @entradas = entradas
       @numNeuron = numNeuronas
       @cantIter = iteraciones
       @indiceEntradas = initializeIndex()
       @vectorCapas = initializeRed()
     end

     # recorre cada capa y guarda la cantidad de entradas que posee.
     def initializeIndex
       indiceEntradas = Array.new
       indiceEntradas << @entradas.length - 1 #La ultima entrada es el valor esperado
       for i in 1..@capas do #identificar cual es la capa 0 o la 1
         indiceEntradas << @numNeuron[i-1]
       end
       indiceEntradas
     end

     def initializeRed
       #TODO
       2
     end
  end
end

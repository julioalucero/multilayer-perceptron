module Perceptor
  class NeuronalNetwork
    attr_accessor  :capas, :numNeuronas, :salidas, :entradas, :vectorCapas, :indiceEntradas

     # @capas = capas numero de capas.
     # @cantIter = Punto de corte, cantidad de entrenamientos.
     # @numNeuron = Contiene vector con la cant de neuronas x capa. Ej [3,2].
     # @entradas = Contiene las entradas principales, vector.
     # @indiceEntradas = Cantidad de entradas en cada capa. Ej. [2,1].
     # @vectorCapas = Contiene las neuronas de cada capa.# Ej. [[neuron1, neuron2],[neuron3]]
     def initialize(capas,entradas,numNeuronas,iteraciones)
       @capas = capas
       @entradas = entradas
       @numNeuron = numNeuronas
       @cantIter = iteraciones
       @indiceEntradas = initializeIndex()
       @vectorCapas = initializeRed()
     end

     def initializeIndex
       #TODO
       3
     end

     def initializeRed
       #TODO
       2
     end
  end
end

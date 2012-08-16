require "gnuplot"
module Perceptron
  class NeuronalNetwork
    attr_accessor  :capas, :entradas, :numNeuronas, :salidas, :vectorCapas, :indiceEntradas, :nu, :momento, :error, :maxIter

    # @capas = numero de capas (contando todas)
    # @entradas = Contiene las entradas principales, vector.Ej. x = [x1, x2, x3, y]
    # @numNeuron e vector con la cant de neuronas x capa. Ej [3,2,1].
    # @cantIter = Punto de corte, cantidad de entrenamientos.
    # @indiceEntradas = Cantidad de entradas en cada capa. Ej. [2, 3, 2].
    # @vectorCapas =  contiene el array con cada objeto Layer a utilizar
    def initialize(capas, entradas, numNeuronas, maxiteraciones, nu, momento)
      @capas = capas
      @entradas = entradas
      @numNeuron = numNeuronas
      @maxIter = maxiteraciones
      @indiceEntradas = initialize_index
      @vectorCapas = initialize_red
      @nu = nu
      @momento = momento
      @error = []
    end

    # recorre cada capa y guarda la cantidad de entradas que posee.
    def initialize_index
      indiceEntradas = []
      indiceEntradas << @entradas[0].length - 1 # La ultima entrada es el valor esperado (y)
      for i in 1..@capas-1 do
        indiceEntradas << @numNeuron[i-1]
      end
      indiceEntradas
    end

    # Crea los objetos Layer necesarios
    # Ej. [ Layer1, Layer2, Layer3 ]
    def initialize_red
      vectorCapas = []
      for i in 0..@capas-1
        vectorCapas << Layer.new(@numNeuron[i], @indiceEntradas[i])
      end
      vectorCapas
    end

    def trainingNetwork
      error = 100 # initialize the error with a big number
      cantIter = 1
      while((error > 0.05) && (cantIter < @maxIter))
        for q in 0..(@entradas.length-1)
          forward_propagation(q)
          back_propagation(q)
          update_weights(@momento)
        end
        error = prom_errores
        @error.clear
        cantIter+=1
        p "Error"
        p error
        p "Cantidad de iteraciones"
        p cantIter
      end
    end

    # calcule the measure error
    def prom_errores
      @error.inject(0) { |accum, error| accum + error } / @error.length
    end

    # recorrer el vector capas y calcular la salida y guarda las entradas
    def forward_propagation(q)
      entradaAux = @entradas[q].clone # to keep the object saved
      entradaAux.delete(entradaAux.last) # Se elimina la última xq es la deseada
      y = []
      for i in 0..(@vectorCapas.length-1)
        y = @vectorCapas[i].calculateOutput(entradaAux)
        entradaAux = y
      end
      @salidas = y
      @error << (((@entradas[q].last-y.first)**2)/2.0)
    end

    # los deltas van a vivir en cada layer
    def back_propagation(q)
      # actualizamos los deltas de la ultima capa
      contador = (@vectorCapas.length-1)
      aux = []
      for i in 0..(@numNeuron.last-1)
        aux <<  (@entradas[q].last - @salidas[i]) * ( @salidas[i] * (1-@salidas[i]))
      end
      @vectorCapas[contador].deltas = aux
      #actualizamos los deltas de las capas inferiores
      while(contador > 0)
       delta = @vectorCapas[contador].deltas
       pesos = @vectorCapas[contador].matrixWeights
       @vectorCapas[contador-1].initializeDeltas(delta,pesos)
       contador -= 1
      end
    end

    def update_weights(m)
      #actualizar dps la ultima capa con el delta que se calcula aca
      if m then
        for i in 0..(@capas-1)
          @vectorCapas[i].updateWeigtWithMomentum(@nu, 0.1)
        end
      else
        for i in 0..(@capas-1)
          @vectorCapas[i].updateWeigt(@nu)	
        end
      end
    end

    def test(matrix)
      @entradas = matrix
      vectorSalidas = []
      for q in 0..@entradas.length-1
        forward_propagation(q)
        vectorSalidas << @salidas
      end
      puntosXY = []
      @entradas.each do |e|
        puntosXY << e[0..-2]
      end

      #separamos las dos clases asi es  mas facil graficar
      clase1 = []
      clase2 = []
      for i in 0..(vectorSalidas.length-1)
        if vectorSalidas[i].first >= 0.5
          clase1 << puntosXY[i]
        else
          clase2 << puntosXY[i]
        end
      end
      graficar_puntos(clase1,clase2)
    end

    def graficar_puntos(clase1,clase2)
      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
          plot.xrange "[0:2]"
          plot.title  "Ejercicio-3"
          plot.ylabel "y"
          plot.xlabel "x"
          x1 = clase1.collect { |fila| fila.first}
          y1 = clase1.collect { |fila| fila.last }
          x2 = clase2.collect { |fila| fila.first}
          y2 = clase2.collect { |fila| fila.last }

          plot.data = [
            Gnuplot::DataSet.new( [x1,y1] ) { |ds|
              ds.with = "dots"
              ds.linewidth = 4
            },
            Gnuplot::DataSet.new( [x2, y2] ) { |ds|
              ds.with = "point"
              ds.linewidth = 4
            }
          ]
        end
      end
    end
  end
end


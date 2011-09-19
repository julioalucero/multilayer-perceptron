require 'gnuplot'

module Perceptron
  class NeuronalNetwork
    attr_accessor  :capas, :entradas, :numNeuronas, :salidas, :vectorCapas, :indiceEntradas, :delta, :nu, :momento, :error

    # @capas = numero de capas (contando todas)
    # @entradas = Contiene las entradas principales, vector.Ej. x = [x1, x2, x3, y]
    # @numNeuron e vector con la cant de neuronas x capa. Ej [3,2,1].
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
      #for i in 0..@numNeuron.last-1
       # @delta << 0
      #end
      @error = Array.new
    end

    # recorre cada capa y guarda la cantidad de entradas que posee.
    def initializeIndex
      indiceEntradas = Array.new
      indiceEntradas << @entradas[0].length - 1 #La ultima entrada es el valor esperado
      for i in 1..@capas-1 do 
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
         prom = 100
#	@cantIter=1
       @cantIter.times do
#	while(prom>0.1)	

       for q in 0..(@entradas.length-1) 
         forwardPropagation(q)
	 backPropagation(q)
         updateWeights(@momento)
       end 
         prom = promErrores
         @error.clear
   	p prom
	p @cantIter
#	@cantIter+=1
	#p @vectorCapas[0].matrixWeights	
       end
  end


   def promErrores # por qué no prom_errores ?!!
     @error.inject(0) { |accum, error| accum + error } / @error.length
   end

   #recorrer el vector capas y calcular la salida y guarda las entradas
   #funciona "bien"
   def forwardPropagation(q)
     entradaAux = @entradas[q].clone
     entradaAux.delete(entradaAux.last) # Se elimina la última xq es la deseada
     y = Array.new
     for i in 0..(@vectorCapas.length-1)
       y = @vectorCapas[i].calculateOutput(entradaAux)
       entradaAux=y
     end
     @salidas = y
     @error << (((y.first- @entradas[q].last)**2)/2.0)
   end

   def backPropagation(q)
     #los deltas van a vivir en cada layer
     contador=(@vectorCapas.length-1)
     #actualizamos los deltas de la ultima capa
     aux=Array.new
     for i in 0..(@numNeuron.last-1)
	aux <<   (@entradas[q].last-@salidas[i])*(1.0+@salidas[i])*(1.0-@salidas[i])
     end
     @vectorCapas[contador].deltas=aux
     #actualizamos los deltas de las capas inferiores
     while(contador >0)	 
      delta =@vectorCapas[contador].deltas	
      pesos = @vectorCapas[contador].matrixWeights	
      @vectorCapas[contador-1].initializeDeltas(delta,pesos)
      contador-=1      
     end
   end

    def updateWeights(m)
      #actualizar dps la ultima capa con el delta que se calcula aca
      if m then
        for i in 0..(@capas-1)
          @vectorCapas[i].updateWeigtWithMomentum(@nu, 0.5)
        end
      
      else
        for i in 0..(@capas-1)
          @vectorCapas[i].updateWeigt(@nu)	
        end
      end

    end

    def test(matrix)
      @entradas = matrix
      vectorSalidas = Array.new
      for q in 0..@entradas.length-1
        vectorSalidas << forwardPropagation(q)
      end
      
      p vectorSalidas
      p "****" *20
      p vectorSalidas.count
      puntosXY = []
      @entradas.each do |e|
        puntosXY << e[0..-2]
      end
      #graficarPuntos(puntosXY, vectorSalidas)
    end


    def graficarPuntos(puntosXY, salidas)

      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
        #  x=vector
          plot.xrange "[0:1]"
          plot.title  "Ejercicio-3"
          plot.ylabel "y"
          plot.xlabel "x"
          x = puntosXY.collect { |fila| fila.first }
          y = puntosXY.collect { |fila| fila.last }

          p salidas.count
          contador = 0

          plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
            ds.with = "point"
            if salidas[contador] == 1 then
              ds.linewidth = 1
            else
              ds.linewidth = 4
            end
            contador += 1
          end
        end
      end
    end
  end
end


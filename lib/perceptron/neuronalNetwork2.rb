require "gnuplot"
module Perceptron
  class NeuronalNetwork2
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
      @indiceEntradas = initializeIndex
      @vectorCapas = initializeRed
      @nu = nu
      @momento = momento
      @error = Array.new
    end

    # recorre cada capa y guarruda la cantidad de entradas que posee.
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
     for i in 0..@capas-1
       vectorCapas << Layer.new(@numNeuron[i], @indiceEntradas[i])
     end
     vectorCapas
   end

   def trainingNetwork
    prom = 100
    cantIter=1
      while((prom>0.05) && (cantIter<@maxIter))	
	       for q in 0..(@entradas.length-1) 
          forwardPropagation(q)
	        backPropagation(q)
          updateWeights(@momento)
         end 
         prom = promErrores
         @error.clear
   	  cantIter+=1
      end
  end


   def promErrores
	   err = 0.0
		 @error.each do |linea|
		 ac = 0.0
		 	linea.each {|val| ac+=val}
			err += ac/3.0
		 end
		 err/@error.length
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
     @salidas = y
		 #codificacion 1 0 0   0
		 #             0 1 0   1
		 #             0 0 1   2 
		 if (@entradas[q].last == 0 )
		 	deseada = [1,0,0]
			else
		  if (@entradas[q].last == 1 )
		 	deseada = [0,1,0]
			else
		 	deseada = [0,0,1]
			end
		 end
			@error <<  [((deseada[0]-@salidas[0])**2.0)/2.0, ((deseada[1]-@salidas[1])**2.0)/2.0,((deseada[2]-@salidas[2])**2.0)/2.0]
	 end

   def backPropagation(q)
     #los deltas van a vivir en cada layer
     #actualizamos los deltas de la ultima capa
     contador=(@vectorCapas.length-1)  
     aux=Array.new
		  if(@entradas[q].last == 0)
		  deseada = [1,0,0]
		  else
		  if (@entradas[q].last == 1)
		  deseada = [0,1,0]
		  else
		  deseada = [0,0,1]
		  end
		  end
			aux1 =  (deseada[0]-@salidas[0])*(@salidas[0]*(1-@salidas[0]))
			aux2 =  (deseada[1]-@salidas[1])*(@salidas[1]*(1-@salidas[1]))
			aux3 =  (deseada[2]-@salidas[2])*(@salidas[2]*(1-@salidas[2]))
			aux << aux1
			aux << aux2
			aux << aux3
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
      vectorSalidas=Array.new	
      for q in 0..@entradas.length-1
        forwardPropagation(q)
				if (@entradas[q].last == 0)
				deseada = [1.0,0.0,0.0]
				else
				if (@entradas[q].last == 1)
				deseada = [0.0,1.0,0.0]
				else
				deseada = [0.0,0.0,1.0]
				end
				end

				vectorSalidas << ((@salidas[0]-deseada[0])**2.0/2.0 + (@salidas[1]-deseada[2])**2.0/2.0 + (@salidas[2]-deseada[2])**2.0/2.0)/3.0 
      end
        err = 0.0
				vectorSalidas.each do |linea|
					err+=linea
				end
				err/@entradas.count
		end 
end
end


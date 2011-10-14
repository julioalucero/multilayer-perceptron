require "gnuplot"

module RbfSom
  class Lvq
    attr_accessor :neuronas, :patrones, :cantClases,:cantNeuronas, :alfa, :epocas
    attr_accessor :tamEntrada, :errores

    # @sizeX y @sizeY contienen las cantidad de neuronas en los ejes
    # @neuronas tiene las coordenadas y los pesos [x,y] que me van a servir para hacer
    #    las lineas que unen las neuronas. Ej  [ {:coord => [x,y], :pesos =>0} ]
    # @tamEntrada tiene la cantidad de entrada para todas las neuronas

    def initialize(patrones, cantClases,cantNeuronas, alfa, epocas)
      @patrones = patrones
      @cantClases = cantClases ##en este caso es igual la cantidad de clases que de neuronas....
      @cantNeuronas = cantNeuronas
      @alfa = Array.new(@cantNeuronas,alfa)       ##velocidad de aprendizaje, decrece con el tiempo, cada neurona tiene uno
      @epocas = epocas
      @neuronas = Array.new
      @tamEntrada = @patrones[0].count - 1
      @errores=[]
      initializePesos
    end


    #cambiar la forma de inicializar los pesos..  
    #poner la cantidad de neuronas y la cant de clases a utilizar,, y definir aleatoriamente..
    
    
    
    def initializePesos
   	@cantNeuronas.times do
	   patron = @patrones[rand(@patrones.count-1)]
           @neuronas << {:class=>rand(@cantClases), :pesos => initPesos}
	end
    end
    
    def initPesos
      aux=[]
	for i in 0...@tamEntrada
		aux << 2*0.5*rand-0.5
	end
      aux
    end


    def entrenamiento
    	@epocas.times do 
	#@patrones.each_index {|i|	
	i = rand(@patrones.count)
	aux = @patrones[i].clone
	aux.delete(aux.last)
        index = busca_ganadora(aux) # te retorna la neurona ganadora	
	actualizarPesos(@patrones[i],index)	
	#}
	end
     end

    def actualizarPesos(patron,clase)	
	deseada=patron.last
	aux=(deseada==clase ? 1:-1)
	tam = @neuronas[clase][:pesos].count
        reasignarAlfa(clase,aux)
        for k in 0...tam
        # actualiza los pesos de c/neurona
        @neuronas[clase][:pesos][k] = @neuronas[clase][:pesos][k] + aux*@alfa[clase]* ( patron[k]- @neuronas[clase][:pesos][k] )
	end
    end

    def reasignarAlfa(clase,aux)
	    aux1 = @alfa[clase] / (1+aux*@alfa[clase])
	    if (aux1 >= 1)
		    @alfa[clase]=0.1
		  else
	    @alfa[clase] = @alfa[clase] / (1+aux*@alfa[clase])
	    end   
    end

    
   
    def distEuclidea(x1,x2)
      suma=0.0
      x1.each_index {|i| suma+= (x1[i]-x2[i])**2.0}
      return Math.sqrt(suma)
    end

    def busca_ganadora(patron)
     #recorrer todas las neuronas
     min = distEuclidea(patron, @neuronas[0][:pesos])
     index=0
     for i in 1...@neuronas.count do
       m = distEuclidea(patron, @neuronas[i][:pesos])
       if ( m < min )
         min = m
         index = i
       end
     end
     index
    end


     def test(patrones)
	patrones.each_index  {|i|
     	
        deseada = patrones[i].last
	aux = patrones[i].clone
	aux.delete(aux.last)
        index = busca_ganadora(aux)
	@errores << (deseada.to_int - index)
	     }
     end

         def graficarPuntos2D
          Gnuplot.open do |gp|
          Gnuplot::Plot.new( gp ) do |plot|
          plot.xrange "[-4:4]"
             plot.title  "Ejercicio-3"
             plot.ylabel "y"
             plot.xlabel "x"

	     x1 = @patrones.collect { |fila| fila.first}
             y1 = @patrones.collect { |fila| fila[1] }
             x2=[]
	     y2=[]
	    
	    @neuronas.each_index do |i| 
		    x2 << @neuronas[i][:pesos].first
		    y2 << @neuronas[i][:pesos].last
	    end



          plot.data = [
           Gnuplot::DataSet.new( [x1,y1] ) { |ds|
           ds.with = "dots"
           ds.linewidth = 2
           },

           Gnuplot::DataSet.new( [x2, y2] ) { |ds|
            ds.with = "point"
            ds.linewidth = 2  } ]
            end
           end
	 end
  end
end









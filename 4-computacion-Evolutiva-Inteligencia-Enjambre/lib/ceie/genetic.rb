require "gnuplot"
module Ceie
  class Genetic
		attr_accessor :poblacion, :cantidad, :tamanioCromosoma, :fitness, :cromosomaMin, :funcion 
		attr_accessor :tamanioNumero, :probabilidad, :qsubm, :epocas, :fitnessReq, :tamanioNumero, :aceptaNegativo
	
	def initialize(cantidad,tamanioCromosoma,fitnessReq,epocas,tamanioNumero,funcion,aceptaNegativo)
		@cantidad = cantidad
		@tamanioCromosoma = tamanioCromosoma
		@aceptaNegativo = aceptaNegativo
		@epocas = epocas
		@fitnessReq = fitnessReq
		@fitness = []
		@probabilidad = []
		@qsubm = []
		@funcion = funcion
		@tamanioNumero = tamanioNumero   ##esto varia de acuerdo al problema
		@poblacion = initializePoblacion
	end

	def initializePoblacion
		@poblacion = []
		@cantidad.times do
			aux =[]
			@tamanioCromosoma.times do
			 aux << rand.round
			end
			@poblacion << aux
	  end
		@poblacion
	end

 	def resolver
		contador = 0
		cantidad = 20
		ptoCruza = 6
		porcentajeMutacion = 10
		evaluarPoblacion
		while((@epocas > contador) && (@fitness.min > @fitnessReq)) 
		 
		 indiceMin = @fitness.index(@fitness.min)
		 @cromosomaMin = @poblacion[indiceMin].clone #guardo el mejor
		 
		 indicesPadres = seleccionarPoblacionRuleta(cantidad)
		 cruza(indicesPadres,ptoCruza)
	   mutacion(porcentajeMutacion)
		
		 #recupero el mejor y lo cambio por el peor
 	 	 indiceMax = @fitness.index(@fitness.max)
		 @poblacion.delete_at(indiceMax)
 	 	 @poblacion.insert(indiceMax,@cromosomaMin)

		 evaluarPoblacion
		 contador+=1
		 graficar if(contador % 10 == 0)
		end
		p index = @fitness.min
		indice = @fitness.index(index)
		p "punto x de la funcion"
		p bin2dec(indice)
		graficar
	end


  def bin2dec(posicion)
    dec = 0.0;
		bin = @poblacion[posicion]
		tamanio = @tamanioNumero
		if(@aceptaNegativo)
		bin.each_index do |i|
		if(i!=0)
			dec += bin[i]* (2**tamanio)
		  tamanio =tamanio- 1
			end
		end
		if(@poblacion[posicion][0] == 1)
		  dec
		else
		  dec = -1 * dec
		end
		else
		bin.each_index do |i|
			dec += bin[i]* (2**tamanio)
		  tamanio =tamanio- 1
			end
			dec
		end
		dec
	end
                                                                                    
	def evaluarPoblacion
		@fitness.clear
		@poblacion.each_index do |i|
				case funcion
				when 1
			   @fitness <<  funcion1(bin2dec(i))
				when 2
			   @fitness <<  funcion2(bin2dec(i))
				when 3
			   @fitness <<  funcion3(bin2dec(i))
	      end
		end
	end

	############aplicamos el metodo de la ruleta rusa###############
	
	def crearProbabilidad
		@probabilidad.clear
		sumaFitness = @fitness.inject {|sum,x| sum+=x }
		@fitness.each do |fitnes|
			@probabilidad << fitnes / sumaFitness
		end
		index=1
		@qsubm.clear
		@probabilidad.each do
			@qsubm << sumarCant(index,@probabilidad)
			index+=1
		end
	end
	
	def seleccionarPoblacionRuleta(cantidad)
	  crearProbabilidad
		indices = []
		cantidad.times do
		r = rand
		indiceaux = @fitness.index(@fitness.min)
		@qsubm.each_index do |i|
			if (@qsubm[i] < r && @qsubm[i+1]>=r)
			 indiceaux = i+1
			end
		end
		   indices << indiceaux
		end
		indices
	end

	def cruza(indicePadres,ptoCruza)
		hijos = []
		indicePadres.each_slice(2) do |indice_0, indice_1|
			hijos << @poblacion[indice_0][0...ptoCruza] + @poblacion[indice_1][ptoCruza...@tamanioCromosoma]
		  hijos << @poblacion[indice_1][0...ptoCruza] + @poblacion[indice_0][ptoCruza...@tamanioCromosoma]
		end
		poblacion = []
		indicePadres.each do |i|
		  poblacion << @poblacion[i]
		end
		poblacion += hijos
		@poblacion = poblacion
	end

	def mutacion(porcentaje)
		@poblacion.each_index do |i|
		 if(rand < porcentaje/100.0)
		  indice = rand(@poblacion[i].count)
			if(@poblacion[i][indice]==0)
			 @poblacion[i][indice]=1
		   else
			 @poblacion[i][indice]=0
		   end
		 end
		end
   end	
	
	#devuelve la suma de los cant componentes del vector
	def sumarCant(cant,vector)
		sum = 0.0
		index = 0
		while(cant > index)
			sum += vector[index]
			index +=1
		end
		sum
	end

	#funciones para el ejercicio1
	#[-512..512]
	def funcion1(x)
	  y = -x * Math.sin(Math.sqrt(x.abs))
	 # y = -x * Math.sin(Math.sqrt(x.abs * (Math::PI / 180.0 )))
		y
	end
  #[0..20]
	def funcion2(x)
		y = x + 5 * Math.sin(3*x) +  8 * Math.cos(5*x)  ##sin esta en radianes
		y
	end
	#fin funciones

    def graficar()
    Gnuplot.open do |gp|
     Gnuplot::Plot.new( gp ) do |plot|

      plot.title  "Ejercicio-1"
      plot.ylabel "y"
      plot.xlabel "x"
			x = []
			y = []
			y << @fitness.min
		  indice = @fitness.index(y.first)
		  x << bin2dec(indice)
			case funcion
				when 1
        plot.xrange "[-512.0:512.0]"
		  	plot.data = [
        Gnuplot::DataSet.new("-x*sin(sqrt(abs(x)))") { |ds|
          ds.with = "lines"
          ds.linewidth = 2
		  		},
        Gnuplot::DataSet.new([x,y]) { |ds|
          ds.with = "linespoint"
          ds.linewidth = 3
		  		ds.title = "Minimo"
		  		}]
				when 2
        plot.xrange "[0.0:20.0]"
				plot.data = [
         Gnuplot::DataSet.new("x + 5*sin(3*x) + 8*cos(5*x)") { |ds|
           ds.with = "lines"
           ds.linewidth = 2
		   		},
         Gnuplot::DataSet.new([x,y]) { |ds|
           ds.with = "linespoint"
           ds.linewidth = 3
		   		ds.title = "Minimo"
		   		}]
				when 3
	  	
        plot.xrange "[-100.0:100.0]"
			plot.data = [
        Gnuplot::DataSet.new("-x*sin(sqrt(abs(x)))") { |ds|
          ds.with = "lines"
          ds.linewidth = 2
	  			},
        Gnuplot::DataSet.new([x,y]) { |ds|
          ds.with = "linespoint"
          ds.linewidth = 3
	  			ds.title = "Minimo"
	  			}]
				end

    end
		end
   end

end
end

require "gnuplot"
module Ceie
  class Enjambre
	
		attr_accessor :cantidad, :particulas, :epocas  
		attr_accessor :rangox, :rangoy, :bestPosGlobal, :funcion 
	
	def initialize(cantidad,rangox,rangoy,epocas,funcion)
		@cantidad = cantidad
		@epocas = epocas
		@rangox = rangox    
		@rangoy = rangoy 
		@bestPosGlobal = [0.0,0.0]
		@funcion = funcion
		@particulas = initializeProblem
	end

	def initializeProblem
		particulas = []		
	  @cantidad.times do
		 particulas << {:pos => [[initRandx,initRandy]], :vel =>[[initRandx,initRandy]], :fitness => [], :bestpos => [0.0,0.0] }
		end
		particulas.each do |particula|
			particula[:fitness] << calculateFitness(particula[:pos][0])
			particula[:bestpos] = particula[:pos][0]
			@bestPosGlobal = particula[:pos][0] if(particula[:fitness][0] < calculateFitness(@bestPosGlobal))
		end
		particulas
	end

	def initRandx
		rand(@rangox[1])-rand(@rangox[0])
	end

	def initRandy
		rand(@rangoy[1])-rand(@rangoy[0])
	end
	
	def resolver
	  c1 = 2.0
		c2 = 2.0
		tiempo = 1
		while(tiempo < @epocas)   #condicion de corte
			@particulas.each do |particula|
				particula[:vel]     << actualizarVel(particula,c1,c2,tiempo)
				particula[:pos]     << actualizarPos(particula,tiempo)
		  	particula[:fitness] << actualizarFitness(particula,tiempo)
				replaceBestPos(particula)
			end
		tiempo +=1
	  graficarSolucion if (tiempo % 100 == 0)
		end
	end

	def actualizarVel(particula,c1,c2,tiempo)
		aux1 = particula[:vel][tiempo-1][0] 
		aux2 = c1 *rand * (particula[:bestpos][0]- particula[:pos][tiempo-1][0])*tiempo 
		aux3 = c2 *rand *  (@bestPosGlobal[0] - particula[:pos][tiempo-1][0])
		auy1 = particula[:vel][tiempo-1][1] 
		auy2 = c1 *rand * (particula[:bestpos][1]- particula[:pos][tiempo-1][1])*tiempo 
		auy3 = c2 *rand *  (@bestPosGlobal[1] - particula[:pos][tiempo-1][1])
		[aux1+aux2+aux3, auy1+auy2+auy3]
	end

	def actualizarPos(particula,tiempo)
	 aux = particula[:pos][tiempo-1][0] + particula[:vel][tiempo][0]
	 auy = particula[:pos][tiempo-1][0] + particula[:vel][tiempo][1]
	 if((aux <= @rangox[1] && aux >= @rangox[0]) && (auy <= @rangoy[1] && auy >= @rangoy[0])) #si no es valido lo eliminamos
	 	[aux,auy]
	 else
	 #darle el maximo para el rango...
	 [particula[:pos][tiempo-1][0],particula[:pos][tiempo-1][1]]
	 end
	end

	def actualizarFitness(particula,tiempo)
		calculateFitness(particula[:pos][tiempo])
	end

	def replaceBestPos(particula)
		if(particula[:fitness].last < calculateFitness(particula[:bestpos]))
			particula[:bestpos] = particula[:pos].last
		end
		if(particula[:fitness].last < calculateFitness(@bestPosGlobal))
			@bestPosGlobal = particula[:pos].last
		end
	end
	
	def calculateFitness(x)
		case @funcion
		when 1
	   return  funcion1(x[0])
		when 2
		 return  funcion2(x[0])
		when 3
	   return  funcion3(x)
    end
  end

	#funciones
	#[-512..512]
	def funcion1(x)
	  -x * Math.sin(Math.sqrt(x.abs))
	end
  #[0..20]
	def funcion2(x)
	 x + 5 * Math.sin(3*x) +  8 * Math.cos(5*x)  ##sin esta en radianes
	end
	#[-100..100] en x;y
	def funcion3(x)
	 (x[0]**2.0 + x[1]**2.0)**0.25 *(Math.sin((50*(x[0]**2.0 + x[1]**2.0)**0.1)+1))**2.0		
	end

	#fin funciones

	def graficarSolucion
  	Gnuplot.open do |gp|
  	Gnuplot::Plot.new( gp ) do |plot|
  		plot.title  "Ejercicio-3"
  		plot.ylabel "y"
  		plot.xlabel "x"
	
		x = @bestPosGlobal
		y = calculateFitness(x)
		case @funcion
		when 1
        	plot.xrange "[-512.0:512.0]"
					plot.data = [
        	Gnuplot::DataSet.new("-x*sin(sqrt(abs(x)))") { |ds|
          	ds.with = "lines"
  	        ds.linewidth = 2
		  		},
        	Gnuplot::DataSet.new([[x[0]],[y]]) { |ds|
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
         	Gnuplot::DataSet.new([[x[0]],[y]]) { |ds|
                ds.with = "linespoint"
	        ds.linewidth = 3
					ds.title = "Minimo"
		   		}]
		end
		end
		end
                
	#	if(@funcion == 3)
  #  		Gnuplot.open do |gp|
  #   		Gnuplot::SPlot.new( gp ) do |plot|
	#				plot.title  "Ejercicio-3"
  #    		plot.ylabel "y"
  #    		plot.xlabel "x"
  #    		plot.xrange "[-100.0:100.0]"
  #    		plot.yrange "[-100.0:100.0]"
	#      	x = @bestPosGlobal
	#      	y = calculateFitness(x)
	#				plot.data = [
  #      	Gnuplot::DataSet.new("x**2+y**2")]
	#				#{ |ds|
	#				#((x**2.0 + y**2.0)**0.25)*(sin((50*(x**2.0 + y**2.0)**0.1)+1))**2.0") 

  #        #	ds.with = "lines"
  #        #	ds.linewidth = 2
	#  			#}
  #      #	Gnuplot::DataSet.new([x,y]) { |ds|
  #      #  	ds.with = "linespoint"
  #      #  	ds.linewidth = 3
	#      #  	ds.title = "Minimo"
	#  		#	}
	#			#]

	#		end
	#	end
	#	end


		end
end
end

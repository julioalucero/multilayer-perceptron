require "gnuplot"
module Ceie
  class GeneticSalesman
    attr_accessor :poblacion, :cantidad, :tamanioCromosoma, :fitness, :cromosomaMin, :funcion 
    attr_accessor :tamanioNumero, :probabilidad, :qsubm, :epocas, :fitnessReq, :tamanioNumero, :aceptaNegativo
    attr_accessor :costos, :cantidad_ciudades

  def initialize(cantidad, tamanioCromosoma, fitnessReq, epocas, tamanioNumero,funcion,aceptaNegativo, costos, cantidad_ciudades)
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
    @costos = costos
    @cantidad_ciudades = cantidad_ciudades
  end

  def initializePoblacion
    @poblacion = []
    ciudades = [0, 1, 2, 3, 4, 5, 6, 7]
    @cantidad.times do
      # sort_by... mezcla aleatoriamente las ciudades
      @poblacion << ciudades.sort_by{rand}[0...8]
    end
    @poblacion
  end

   def resolver
    contador = 0
    cantidad = 4
    porcentajeMutacion = 10
    evaluarPoblacion
    while((@epocas > contador) && (@fitness.min > @fitnessReq))
     
     indiceMin = @fitness.index(@fitness.min)
 
     @cromosomaMin = @poblacion[indiceMin].clone #guardo el mejor
     
     indicesPadres = seleccionarPoblacionRuleta(cantidad)
     cruza(indicesPadres)
     p @poblacion.count
     #mutacion(porcentajeMutacion)
    
     #recupero el mejor y lo cambio por el peor
     indiceMax = @fitness.index(@fitness.max)
     @poblacion.delete_at(indiceMax)
     @poblacion.insert(indiceMax,@cromosomaMin)



     evaluarPoblacion
     contador+=1
    end
    p index = @fitness.min
    indice = @fitness.index(index)
    p "punto x de la funcion"
    p @poblacion[indice]
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
        when 4
         @fitness <<  funcion4(@poblacion[i])
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

  def cruza(indicePadres)
    # operador basado en cruce basado en ciclos CX
    poblacion = []
    indicePadres.each_slice(2) do |indice_padre, indice_madre|
      hijo  = []
      hija  = []
      padre = []
      madre = []
      padre = @poblacion[indice_padre]
      madre = @poblacion[indice_madre]
  #   if padre == madre then
  #     padre = @poblacion[1]
  #     madre = @poblacion[4]
  #   end
  #  padre = [1, 2, 3, 4, 5, 6, 7, 0]
  #  madre = [3, 7, 5, 1, 6, 0, 2, 4]
      #p "padre = #{padre}"
      #p "madre = #{madre}"
      # punto correspondencia = i
      i = 3
#      correspondencia = Hash.new{ padre[i], madre[i], padre[i+1], madre[i+1], padre[i+2], madre[i+2] }
      correspondencia = Hash.new
      correspondencia[padre[i]] = madre[i]
      correspondencia[padre[i+1]] = madre[i+1]
      correspondencia[padre[i+2]] = madre[i+2]

      hijo[i] = madre[i]
      hija[i] = padre[i]
      hijo[i+1] = madre[i+1]
      hija[i+1] = padre[i+1]
      hijo[i+2] = madre[i+2]
      hija[i+2] = padre[i+2]


       i.times do |e|
         if !hijo.include?(padre[e]) then
           hijo[e] = padre[e]
         else
           hijo[e] = intercambio_hijo(padre[e], correspondencia, hijo)
         end
       end

       i.times do |e|
         if !hija.include?(madre[e]) then
           hija[e] = madre[e]
         else
           hija[e] = intercambio_hija(madre[e], correspondencia, hija)
         end
       end

        # -------------------------------- ultimos

        # i = 5
        i += 3
        for e in i...8 do
          if !hijo.include?(padre[e]) then
            hijo[e] = padre[e]
          else
            hijo[e] = intercambio_hijo(padre[e], correspondencia, hijo)
          end
        end

        j = 6
        for z in j...8 do
          if !hija.include?(madre[z]) then
            hija[z] = madre[z]
          else
            hija[z] = intercambio_hija(madre[z], correspondencia, hija)
          end
        end

        #p "padre #{padre.uniq}"
        #p "madre #{madre.uniq}"
        #p "hijo  #{ hijo.uniq}"
        #p "hija  #{ hija.uniq}"
        poblacion << padre
        poblacion << madre
        poblacion << hijo  if padre.uniq.count == 8 and !padre.include?(nil)
        poblacion << hija  if padre.uniq.count == 8 and !padre.include?(nil)
        poblacion << madre if padre.uniq.count != 8 or padre.include?(nil)
        poblacion << padre if padre.uniq.count != 8 or padre.include?(nil)

      end
    @poblacion = poblacion
  end

  def intercambio_hijo(x, correspondencia, hijo)
    corr =  correspondencia.key(x)
    key =  correspondencia.key(corr)
    if !hijo.include?(corr)
      corr
    else
      key
    end
  end

  def intercambio_hija(x, correspondencia, hija)
    corr =  correspondencia[x]
    key =  correspondencia[corr]
    if !hija.include?(corr)
      corr
    else
      key
    end
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

  def funcion4(camino)
    inicio = camino.first
    y = 0.0
    ciudad_inicio = camino.first
    camino.each_index do | i |
      inicio  = camino[i]
      destino = camino[i+1]
      if destino != nil
        y += @costos[inicio][destino]
      end
    end
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

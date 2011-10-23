require "gnuplot"
module Fam
  class Fuzzy
    attr_accessor :tiempo, :puertaAbierta, :tempRef
    attr_accessor :tempExt, :tempInt,:voltaje, :amperes
    attr_accessor :conjuntoEntrada

    # entradas es un vector de temperaturas que varia de 10 a 12º como para empezar
    # tiempo es en segundos
    # el amperaje da calor
    # el voltaje refresca la vida


    # conjuntoEntrada es una matriz donde cada fila representa las temperaturas
    # Muy Bajas - Baja - Normal - Alta - Muy Alta

    def initialize(tiempo)
      @tiempo = tiempo
      @puertaAbierta = false
      @tempRef = crear_temperatura_referencia
      @tempExt = crear_temperaturaExterna
      @voltaje = 0.0
      @amperes = 0.0
      @tempInt = [22]
      @conjuntoEntrada = [[-10.0, -1.0, -4.5],[-3.0, 0.0, -1.5], [-1.5,1.5,0.0], [0.0, 3.0, 1.5], [1.0, 10.0, 4.5]]
      @conjuntoSalida  = [[-100.0, -30.0,-65.0],[-50.0,0.0,-25.0],[-0.20,0.20,0.0], [0.0, 3.2, 1.6], [1.5, 3.8, 2.65]] 
      @deltaTemp = 0.0
    end

    def resolver
      @tiempo.times do |t|
        if ( t%10 == 0)      #cada 10 segundos una iteracion
          @deltaTemp = @tempRef[t] - @tempInt.last
          intensidad = calcularIntensidad
          if (intensidad >=0.0)
            @voltaje =0.0
            @amperes =  intensidad
          elsif (intensidad< 0.0)
            @amperes = 0.0
            @voltaje = -intensidad
          end
          if (rand < 1.0 / 360.0) then
            @puertaAbierta = true
          end
          tempInterior(t) # guardamos la temperatura interior
        end
        @puertaAbierta = false
      end
    end

    # aca aplicamos logica difusa
    def calcularIntensidad
      grados = fuzzyfication
      intensidad = defuzzyfication(grados)
      intensidad
    end

    def crear_temperaturaExterna
      @tempExt = []
      t1 = Array.new(600, 20.0)
      t2 = Array.new(600, 15.0)
      @tempExt << t1 << t2 << t1 << t2 << t1 << t2
      @tempExt.flatten
    end

    def crear_temperatura_referencia
      t1 = Array.new(600, 18.0)
      t2 = Array.new(600, 22.0)
      @tempRef = []
      @tempRef << t1 << t2 << t1 << t2 << t1 << t2
      @tempRef.flatten
    end

    def tempInterior(t)
      if(@puertaAbierta)
        @tempInt << 0.169 * @tempInt.last + 0.831 * @tempExt[t] + 0.112 * (@amperes**2.0) - 0.002*@voltaje
      else
        @tempInt << 0.912 * @tempInt.last + 0.088 * @tempExt[t] + 0.604 * (@amperes**2.0) - 0.0121*@voltaje
      end
    end


    def fuzzyfication
      grados = []
      @conjuntoEntrada.each do |coord|
        grados << pertenencia(coord[0], coord[1], coord[2], @deltaTemp)
      end
      grados
    end

    def defuzzyfication(grados)
      sumaSup = 0.0
      @conjuntoSalida.each_index{ |i| sumaSup += @conjuntoSalida[i][2] * grados[i] * areaT(i) }
      sumaInf = 0.0
      @conjuntoSalida.each_index{|i| sumaInf+= grados[i]*areaT(i)}
      sumaSup / sumaInf
    end

    def pertenencia(a, b, c, x)
      if x >= a  &&  x <= c then
        0.25 + (0.75 / (c-a)) * (x - a)
      elsif x > c && x <= b then
        1.0 - (0.75 / (b-c)) * (x-c)
      else
        0
      end
    end

    def areaT(index)
      area = ( (@conjuntoSalida[index][0] - @conjuntoSalida[index][1])) / 2.0 # la altura es 1
      area
    end

    def graficarTemperaturas()
      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
          plot.xrange "[0:3600]"
          plot.title  "Ejercicio-1"
          plot.ylabel "Temperatura"
          plot.xlabel "Tiempo"

          #creamos el vector incongnitas para la tempInterior pq se muestrea cada 10s
          aux = []
          i = 0
          360.times do
            aux << i + 10
            i += 10
          end

          plot.data = [
            Gnuplot::DataSet.new( @tempRef ) { |ds|
              ds.with      = "lines"
              ds.linewidth = 2
              ds.title     = "deseada"
            },
            Gnuplot::DataSet.new([aux, @tempInt] ) { |ds|
              ds.with      = "lines"
              ds.linewidth = 3
              ds.title     = "interna"
            },
            Gnuplot::DataSet.new( @tempExt ) { |ds|
              ds.with      = "lines"
              ds.linewidth = 2
              ds.title     = "externa"
            }
          ]
        end
      end
    end
  end
end


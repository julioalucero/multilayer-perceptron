require "gnuplot"

module RbfSom
  class Som
    attr_accessor :neuronas, :patrones, :sizeX ,:sizeY, :nu, :epocas
    attr_accessor :salida ,:cantNeuronas ,:coefVecinos, :tamEntrada

    # reduccion del coeficiente @nu linealmente (PODRIA SER EXPONENCIALMENTE o dejarlos fijo. ver opciones)
    # reduccion del coeficiente @coefVecinos linealmente
    # @sizeX y @sizeY contienen las cantidad de neuronas en los ejes
    # @neuronas tiene las coordenadas y los pesos [x,y] que me van a servir para hacer
    #    las lineas que unen las neuronas. Ej  [ {:coord => [x,y], :pesos =>0} ]
    # @tamEntrada tiene la cantidad de entrada para todas las neuronas

    def initialize(patrones, sizeX, sizeY, nu, epocas)
      @patrones = patrones.shuffle!
      @sizeX = sizeX
      @sizeY = sizeY
      @nu = nu
      @epocas = epocas
      @cantNeuronas = @sizeY * @sizeX
      @neuronas = Array.new
      @tamEntrada = @patrones[0].count - 1
      @coefVecinos = 0.1
      initializePesos
      @contador = 0
    end

    def initializePesos
      for i in 0...@sizeX
        aux = []
        for j in 0...@sizeY # -2 porque la ultima es la deseada...
          @neuronas << {:coord => [i,j], :pesos => 0}
        end
      end
      @neuronas.each do | neurona |
        aux = []
        @tamEntrada.times do
          aux << 2.0 * 0.5 * rand - 0.5
        end
        neurona[:pesos] = aux
      end
    end

    def entrenamiento
      iter = 1
      graficar_puntos("Inicio")
      @epocas.times do
        @patrones.each_index do |i|
          aux = @patrones[i].clone
          aux = aux[0...-1]
          index = buscar_ganadora(aux)
          vecinos = buscar_vecinos(index)
          vecinos << index
          vecinos.uniq!
          actualizar_pesos(vecinos, i)
        end

        @nu = @nu - @nu * (iter.to_f / @epocas.to_f) + 0.01
        @coefVecinos = @coefVecinos - @coefVecinos * (iter.to_f / @epocas.to_f) + 0.01
        iter += 1
      end
      graficar_puntos("Fin")
    end

    def distEuclidea(x1,x2)
      suma=0.0
      x1.each_index {|i| suma+= (x1[i]-x2[i])**2.0}
      return Math.sqrt(suma)
    end

    def buscar_ganadora(patron)
     #recorrer todas las neuronas
     min = distEuclidea(patron, @neuronas[0][:pesos])
     index = 0
     for i in 0...@cantNeuronas do
       m = distEuclidea(patron, @neuronas[i][:pesos])
       if (m < min)
         min = m
         index = i
       end
     end
     index
    end

    def buscar_vecinos(index)
      vecinos = []
      @neuronas.each_index do |i|
        if (distEuclidea( @neuronas[index][:pesos], neuronas[i][:pesos]) < @coefVecinos)
         vecinos << i
        end
      end
      vecinos
    end

    # p es el número de iteración y hace referencia al número de patron ya que TODO ...
    def actualizar_pesos(vecinos, p)
      vecinos.each { |i| update(i, p)}  #actualiza la neurona i
    end

    def update(i, p)  # p hace referencia al patron
      tam = @neuronas[i][:pesos].count
      for k in 0...tam
        # actualiza los pesos de c/neurona
        @neuronas[i][:pesos][k] += @nu * (@patrones[p][k] - @neuronas[i][:pesos][k])
      end
    end


    def graficar_puntos(i)
      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
          plot.xrange "[-3:3]"
          plot.yrange "[-3:3]"
          plot.title "interacion #{i}"
          plot.ylabel "y"
          plot.xlabel "x"

          pesos = []
          @neuronas.each do |neurona|
            pesos << neurona[:pesos]
          end
          plot.data = [
            Gnuplot::DataSet.new([pesos]) do |ds|
              ds.with = "points"
              ds.linewidth = 2
            end
          ]
        end
      end
    end
  end
end

require 'gnuplot'

module Perceptron
  class Neuron
    attr_accessor :nInputs, :w, :nu, :umbral, :epocas, :error, :bool

    def initialize(nInputs, nu, epocas, bandera)
      @nInputs = nInputs
      @nu = nu
      @umbral = 2 * 0.5 * rand - 0.5
      @epocas = epocas
      @w = initialize_random
      @error = []
      @bool = bandera
    end

    # recibe el array de entrenamiento.
    # entrena y actualiza los pesos
    def training(matrix)
      @epocas.times do
        contador = 0
        matrix.each do | pattern |
          contador += 1
          y = calculate(pattern)
          update(pattern, y)
        #  graficar if (contador % 20  == 0)
        end
      end
    end

    def trainingWithIndices(matrix, indices)
      @epocas.times do
        contador = 0
        while contador != 799
          indice = indices[contador]
          y = calculate(matrix[indice])
          update(matrix[indice], y)
          contador += 1
        end
      end
    end

    def test(matrix, indices)
      contador = 0
      @error = 0

      # 199 is 20% of 1000
      while contador != 199
        indice = indices[contador]
        y = dot_product(matrix[indice])
        y = y - @umbral
        yd = matrix[indice].last
        y = sigmoide(y, 1)
        y = y > 0 ?  1 : -1
        @error += 1 if yd != y
        contador += 1
      end
    end

    private

    # Initialize all the values for the w (weigths) between [-0.5, 0.5]
    def initialize_random
      @w = []
      @nInputs.times do
         @w << (2 * 0.5 * rand - 0.5)
      end
      @w
    end

    def calculate(pattern)
      y = dot_product(pattern) # < @w, pattern >
      y = y - @umbral
      y = sigmoide(y,1)
    end

    def sigmoide(y, a)
      y= (1 -Math.exp(-a*y)) / (1 + Math.exp(-a*y))
    end

    # w(n+1) = w(n) - umbral*x(n)
    def update(training, y)
      shift = constantProduct(training, y)
      @w = subtractArray(shift)
    end

    def dot_product(training)
      sum = 0
      @w.zip(training) { |a, b| sum += a * b }
      sum
    end

    # umbral/2 [yd - y(n)] * x(n)
    def constantProduct(training, y)
      shift = []
      constant = @nu/2 * (training.last - y)
      for i in 0..(@nInputs - 1)
        shift << training[i] * constant
      end
      @umbral = @umbral - constant
      shift
    end

    # w(n) - constantProduct
    def subtractArray(shift)
      wUpdate = []
      for i in 0..(@nInputs -1)
        wUpdate << @w[i] + shift[i]
      end
      wUpdate
    end

    def graficar
      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
          plot.title  "Ejercicio-1"
          plot.ylabel "y"
          plot.xlabel "x"
          plot.xrange "[-2.0:2.0]"
          plot.yrange "[-2.0:2.0]"
          if (bool == true)
           x1 = [1.0,-1.0,1.0]
           y1 = [1.0,1.0,-1.0]
           x2 = [-1.0]
           y2 = [-1.0]
           else
           x1 = [1.0,-1.0]
           y1 = [1.0,-1.0]
           x2 = [-1.0,1.0]
           y2 = [1.0,-1.0]
        end

        a = -1.0*(@w.first / @w.last)
        b = @umbral / @w.last
        plot.data = [
          Gnuplot::DataSet.new("#{a}*x + #{b}") { |ds|
            ds.with = "lines"
            ds.linewidth = 2
          },
          Gnuplot::DataSet.new([x1,y1]) { |ds|
            ds.with = "points"
            ds.linewidth = 4
          },
          Gnuplot::DataSet.new([x2,y2]) { |ds|
            ds.with = "points"
            ds.linewidth = 4
          }, 
        ]
      end
    end
  end

  end
end

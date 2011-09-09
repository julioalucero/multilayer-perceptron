require 'gruff'

module Perceptor
  class Neuron
    attr_accessor :nInputs, :w, :nu, :umbral, :epocas, :error

    def initialize(nInputs, nu, epocas)
      @nInputs = nInputs
      @nu = nu
      @umbral = 2 * 0.5 * rand - 0.5
      @epocas = epocas
      @w = initializeRandom
      @error = Array.new
    end

    def initializeRandom
      @w=Array.new
      @nInputs.times do
         @w.push(2 * 0.5 * rand - 0.5)
      end
      @w
    end

    # recibe el array de entrenamiento.
    # entrena y actualiza los pesos
    def training(matrix)
      @epocas.times do
        contador = 0
        matrix.each do |training|
          contador += 1
          y = calculate(training)
          update(training, y)
          graficar(contador, "ejercicio1") if  contador.modulo(10) == 0
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

    def graficar(k, ejercicio)
      w1 =  @w.first
      w2 =  @w.last
      pendiente = w1/w2
      ordenada  = @umbral/w2

      g = Gruff::Line.new
      extra = rand(10)
      title = "Graph" + k.to_s + extra.to_s
      g.title = title
      p title

      g.labels = {0 => '-2', 1 => '-1', 2 => '0', 3 => '1', 4 => '2'}

      y = Array.new
      for i in 0..4 do
        y[i] = ordenada - (pendiente * (i-2))
      end

      g.data("ordenada", [0,0,0,0,0])
      g.data("entrenamiento", y)
      nombre = "prueba-#{k}.png"
      g.write("images/ejercicio1/#{nombre}")
    end

    def calculate(training)
      y = dot_product(training)
      y = y - @umbral
      y = sigmoide(y,1)
    end

    def sigmoide(y,a)
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

    def test(matrix, indices)
      contador = 0
      @error = 0
      while contador != 199
        indice = indices[contador]
        y = dot_product(matrix[indice])
        y = y - @umbral
        yd = matrix[indice].last
        y = sigmoide(y, 1)
        y = if (y > 0) then 1 else -1 end
        @error += 1 if yd != y
        contador += 1
      end
    end
  end
end

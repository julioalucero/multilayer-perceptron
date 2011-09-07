require 'gruff'

module Perceptor
  class Neuron
    attr_accessor :nInputs, :w, :nu, :umbral, :epocas

    def initialize(nInputs, nu, epocas)
      @nInputs = nInputs
      @nu = nu
      @umbral = 2 * 0.5 * rand - 0.5
      @epocas = epocas
      @w = initializeRandom
    end

    def initializeRandom
      @w=Array.new
      @nInputs.times do
         @w.push(2 * 0.5 * rand - 0.5)
      end
      p @w
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
          graficar(contador) if  contador.modulo(10) == 0
        end
      end
    end

    def graficar(k)
      w1 =  @w.first
      w2 =  @w.last
      pendiente = w1/w2
      ordenada  = @umbral/w2

      g = Gruff::Line.new
      g.title = "My Graph + #{k}"
      g.labels = {0 => '-2', 1 => '-1', 2 => '0', 3 => '1', 4 => '2'}

      y = Array.new
      for i in 0..4 do
        y[i] = ordenada - (pendiente * (i-2))
      end

      g.data("entrenamiento", y)
      nombre = "prueba-#{k}.png"
      g.write("images/+#{nombre}")
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
  end
end

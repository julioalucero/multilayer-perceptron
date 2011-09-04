module PerceptorSimple
  class TrainingPS
    attr_accessor :nInputs, :w, :umbral, :w0

    def initialize(nInputs, umbral)
      @nInputs = nInputs
      @w = initializeRandom
      @umbral = umbral
      @w0 = 2 * 0.5 * rand - 0.5
    end

    def initializeRandom
      # TODO debería saber solo cuantas entradas tienen
      [2 * 0.5 * rand - 0.5, 2 * 0.5 * rand - 0.5]
    end

    # recibe el array de entrenamiento.
    # entrena y actualiza los pesos
    def training(matrix)
      matrix.each do |training|
        y = calculate(training)
        update(training, y)
      end
    end

    def calculate(training)
      y = dot_product(training)
      y = y - w0
      y < 0 ? -1 : 1
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
    def constantProduct(training, yd)
      shift = []
      constant = @umbral/2 * (yd - training.last)
      for i in 0..1
        shift << training[i] * constant
      end
      @w0 = @w0 + @umbral * (yd - training.last) * -1
      shift
    end

    # w(n) - constantProduct
    def subtractArray(shift)
      wUpdate = []
      for i in 0..1
        wUpdate << @w[i] - shift[i]
      end
      wUpdate
    end
  end
end

module PerceptorSimple
  class TrainingPS
    attr_accessor :nInputs, :w, :u, :tol

    def initialize(nInputs, u, tol)
      @nInputs = nInputs
      @w = initializeRandom
      @u = u
      @tol = tol
    end

    def initializeRandom
      i = 1
      randomArray = []
      random = Random.new
      while i <= @nInputs do
        randomArray << random.rand(0.5) * ((-1)**i)
        i += 1
      end
      randomArray
    end

    def test(matrix)
      matrix.each do |training|
        yd = calculate(training)
        update(training, yd)
      end
    end

    def calculate(training)
      y = dot_product(training)
      y < 0 ? -1 : 1
    end

    # w(n+1) = w(n) - u*x(n)
    def update(training, yd)
      shift = constantProduct(training, yd)
      @w = subtractArray(shift)
    end

    def dot_product(training)
      sum = 0
      @w.zip(training) { |a, b| sum += a * b }
      sum
    end

    # u/2 [yd - y(n)] * x(n)
    def constantProduct(training, yd)
      shift = []
      constant = @u/2 * (yd - training.last)
      for i in 0..8
        shift << training[i] * constant
      end
      shift
    end

    # w(n) - constantProduct
    def subtractArray(shift)
      wUpdate = []
      for i in 0..8
        wUpdate << @w[i] - shift[i]
      end
      wUpdate
    end
  end
end

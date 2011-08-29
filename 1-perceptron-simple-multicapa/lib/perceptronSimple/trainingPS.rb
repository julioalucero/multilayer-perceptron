module PerceptorSimple
  class TrainingPS
    attr_accessor :nInputs, :w, :u

    def initialize(nInputs, u)
      @nInputs = nInputs
      @w = initializeRandom
      @u = u
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
        yd = training.last
        if calculate(training) == yd
          p "dio bien"
        else
          p "dio mal"
          update(training)
        end
      end
    end

    def calculate(training)
      y = dot_product(training)
      y < 0 ? -1 : 1
    end

    # w(n+1) = w(n) - u*x(n)
    def update(training)
      shift = constantProduct(training)
      @w = subtractArray(shift)
    end

    def dot_product(training)
      sum = 0
      @w.zip(training) { |a, b| sum += a * b }
      sum
    end

    # u * x(n)
    def constantProduct(training)
      shift = []
      for i in 0..8
        shift << training[i] * @u
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

module PerceptorSimple
  class TrainingPS
    attr_accessor :nInputs, :w

    def initialize(nInputs)
      @nInputs = nInputs
      @w = initializeRandom
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
        end
      end
    end

    def calculate(training)
      y = dot_product(training)
      y < 0 ? -1 : 1
    end

    def dot_product(training)
      sum = 0
      @w.zip(training) { |a, b| sum += a * b }
      sum
    end
  end
end

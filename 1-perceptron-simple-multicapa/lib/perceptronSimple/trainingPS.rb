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
  end
end

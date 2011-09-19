module RbfSom
  class Rbf
    attr_accessor :k, :patrones, :conjuntos

    def initialize(k, patrones)
      @k = k
      @patrones = patrones
      @conjuntos = []
    end

  end
end

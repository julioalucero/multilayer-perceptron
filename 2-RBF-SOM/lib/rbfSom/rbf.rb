module RbfSom
  class Rbf
    attr_accessor :k, :conjuntos, :patrones

    def initialize(k, patrones)
      @k = k
      @conjuntos = []
      inicializarConjuntos(patrones)
    end

    def inicializarConjuntos(patrones)
      patrones.each do | patron |
        @conjuntos << { :patron => patron, :clase => rand(@k) }
      end
    end
  end
end

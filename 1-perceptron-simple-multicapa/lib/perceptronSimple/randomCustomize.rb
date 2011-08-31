module PerceptorSimple
  class RandomCustomize
    attr_accessor :matrix

    # generar pares de numeros con una desviacion dada alrededor de una posicion
    # dada por xpos e ypos

    def initialize(desviacion, cantidad, xpos, ypos)
      @matrix = Array.new
      cantidad.times do
        @matrix.push([xpos + 2 * desviacion * rand - desviacion , ypos + 2 * desviacion * rand - desviacion ])
      end
    end
  end
end

module Perceptor
  class RandomCustomize
    attr_accessor :matrix

    # Selecciona la cantidad de puntos a utilizar

    def initialize(desviacion, cantidad, xpos, ypos, zpos, yd)
      if zpos == nil
        initialize2d(desviacion, cantidad, xpos, ypos, yd)
      else
        initalize3d(desviacion, cantidad, xpos, ypos, zpos, yd)
      end
    end

    # generar pares de numeros con una desviacion dada alrededor de una posicion
    # dada por xpos e ypos

    def initialize2d(desviacion, cantidad, xpos, ypos, yd)
      @matrix = Array.new
      cantidad.times do
        @matrix.push([xpos + 2 * desviacion * rand - desviacion, ypos + 2 * desviacion * rand - desviacion, yd])
      end
    end

    # generar pares de numeros con una desviacion dada alrededor de una posicion
    # dada por xpos, ypox y zpos.

    def initalize3d(desviacion, cantidad, xpos, ypos, zpos, yd)
      @matrix = Array.new
      cantidad.times do
        @matrix.push([xpos + 2 * desviacion * rand - desviacion, ypos + 2 * desviacion * rand - desviacion, zpos + 2 * desviacion * rand - desviacion, yd])
      end
    end
  end
end

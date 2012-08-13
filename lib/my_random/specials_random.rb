module MyRandom
  class SpecialsRandom
    attr_accessor :matrix

    # it creates a random arrays of array of random numbers
    # beetween the desviation and the points wishes.
    # Also add a wish_ouput to use after in neuronal networs
    def initialize(desviation, quantity, x, y, z, wish_output)
      if !z
        initialize_2d(desviation, quantity, x, y, wish_output)
      else
        initalize_3d(desviation, quantity, x, y, z, wish_output)
      end
    end

    # Function for 2d points, x and y
    def initialize_2d(desviacion, cantidad, xpos, ypos, yd)
      @matrix = []
      cantidad.times do
        @matrix << ([xpos + 2 * desviacion * rand - desviacion, ypos + 2 * desviacion * rand - desviacion, yd])
      end
    end

    # Function for 3d points, x, y and z
    def initalize_3d(desviacion, cantidad, xpos, ypos, zpos, yd)
      @matrix = Array.new
      cantidad.times do
        @matrix.push([xpos + 2 * desviacion * rand - desviacion, ypos + 2 * desviacion * rand - desviacion, zpos + 2 * desviacion * rand - desviacion, yd])
      end
    end
  end
end

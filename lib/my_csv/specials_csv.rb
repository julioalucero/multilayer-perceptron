module MyCsv
  class SpecialsCsv
    attr_accessor :file_path, :matrix, :trainingIndices, :testIndices

    def initialize(file_path)
      @file_path = file_path
      @matrix = to_a
      @trainingIndices = []
      @testIndices = []
    end

    def to_a
      array = IO.readlines(@file_path)
      @matrix = to_integers(array)
    end

    def to_integers(array)
      matrizAuxiliar = Array.new
      array.each { |a|  matrizAuxiliar << a.split(',') }
      matrizAuxiliar.each { |s| s.collect! { |x| x.to_f } }
    end

    # Create indices to get a randon partition
    # of the training and test.
    # It is saved on @trainingIndices and @testIndices
    def createIndices(porcentaje, cantidadParticiones)
      # creo un vector con los indices de mi tamaño de la matrix
      tamanio = @matrix.length

      # vector con los indices
      vectorAuxiliar = []
      for i in 0..(tamanio-1)
        vectorAuxiliar << i
      end

      # hago la particion. Example: 1000 => 800 / 200
      cantidadTraining = (porcentaje / 100.0 * tamanio).round
      cantidadTest = tamanio - cantidadTraining

      # recorro la cantidad de particiones y voy creando y agregando
      # a los respectivos arrays los índices
      cantidadParticiones.times do
        vectorAuxiliar.shuffle!
        aux1 = []
        aux2 = []

        # ingreso los indices
        for j in 0..(cantidadTraining - 1)
          aux1 << vectorAuxiliar[j]
        end

        for k in cantidadTraining..(tamanio -1)
          aux2 << vectorAuxiliar[k]
        end

        # ingresos en las variables del objeto el resultado.
        @trainingIndices << aux1
        @testIndices     << aux2
      end
    end
  end
end

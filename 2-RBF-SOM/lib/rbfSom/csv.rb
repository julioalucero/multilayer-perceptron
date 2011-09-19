module RbfSom
  class Csv
    attr_accessor :file_path, :matrix, :trainingIndices, :testIndices

    def initialize(file_path)
      @file_path = file_path
      @matrix = to_a
      @trainingIndices = Array.new
      @testIndices = Array.new
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

    # Crea los indices para lograr una partición aleatoria
    # de los entrenamientos y las pruebas

    def createIndices(porcentaje, cantidadParticiones)
      # creo un vector con los indices de mi tamaño de la matrix
      tamanio = @matrix.length

      # vector con los indices
      vectorAuxiliar = Array.new
      for i in 0..(tamanio-1)
        vectorAuxiliar << i
      end

      # hago la particion. Ej: 1000 => 800 / 200

      cantidadTraining = (porcentaje / 100.0 * tamanio).round
      cantidadTest = tamanio - cantidadTraining

      # recorro la cantidad de particiones y voy creando y agregando
      # a los respectivos arrays los índices

      cantidadParticiones.times do

        # shuffle! = mezcla el vector

        vectorAuxiliar.shuffle!
        aux1=Array.new
        aux2=Array.new

        # ingreso los indices

        for j in 0..(cantidadTraining - 1)
          aux1.push(vectorAuxiliar[j])
        end

        for k in cantidadTraining..(tamanio -1)
          aux2.push(vectorAuxiliar[k])
        end

        # ingresos en las variables del objeto el resultado.

        @trainingIndices.push(aux1)
        @testIndices.push(aux2)
      end
    end
  end
end

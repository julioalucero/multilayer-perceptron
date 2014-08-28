require 'spec_helper'

module Perceptron
  describe Neuron do

    def matrix(csv, desviation, quantity)

      matrixPrueba1 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0,  1.0, nil,  1)
      matrixPrueba2 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0, -1.0, nil,  1)
      matrixPrueba3 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0,  1.0, nil,  1)
      matrixPrueba4 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0, -1.0, nil, -1)

      matrix = matrixPrueba3.matrix +  matrixPrueba2.matrix +
               matrixPrueba1.matrix +  matrixPrueba4.matrix +
               csv.matrix

      matrix.shuffle!
      matrix
    end

    def matrix_2(csv, desviation, quantity)
      matrixPrueba1 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0, -1.0, -1.0,  1)
      matrixPrueba2 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0, -1.0,  1.0,  1)
      matrixPrueba3 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0,  1.0, -1.0, -1)
      matrixPrueba4 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0,  1.0,  1.0,  1)
      matrixPrueba5 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0, -1.0, -1.0, -1)
      matrixPrueba6 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0, -1.0,  1.0, -1)
      matrixPrueba7 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0,  1.0, -1.0,  1)
      matrixPrueba8 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0,  1.0,  1.0, -1)

      matrixPruebas = matrixPrueba1.matrix +  matrixPrueba2.matrix + matrixPrueba3.matrix +
        matrixPrueba4.matrix +  matrixPrueba5.matrix + matrixPrueba6.matrix +
        matrixPrueba7.matrix +  matrixPrueba8.matrix + csv.matrix

      matrixPruebas.shuffle!
    end

    def matrix_3(csv, desviation, quantity)
      matrixPrueba1 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0, -1.0, -1.0,  1)
      matrixPrueba2 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0, -1.0,  1.0,  1)
      matrixPrueba3 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0,  1.0, -1.0,  1)
      matrixPrueba4 = MyRandom::SpecialsRandom.new(desviation, quantity, -1.0,  1.0,  1.0,  1)
      matrixPrueba5 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0, -1.0, -1.0, -1)
      matrixPrueba6 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0, -1.0,  1.0, -1)
      matrixPrueba7 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0,  1.0, -1.0,  1)
      matrixPrueba8 = MyRandom::SpecialsRandom.new(desviation, quantity,  1.0,  1.0,  1.0, -1)

      matrixPruebas = matrixPrueba1.matrix +  matrixPrueba2.matrix + matrixPrueba3.matrix +
        matrixPrueba4.matrix +  matrixPrueba5.matrix + matrixPrueba6.matrix +
        matrixPrueba7.matrix +  matrixPrueba8.matrix + csv.matrix

      matrixPruebas.shuffle!
    end

    describe "or exercise" do
      it "all the value should be between (0.95, 1.09)" do
        csv_or = MyCsv::SpecialsCsv.new('or.csv')

        neuron = Neuron.new(2, 0.5, 10, true)
        neuron.training(matrix(csv_or, 0.05, 20))

        pesos = neuron.w
        w1 =    neuron.w.first
        w2 =    neuron.w.last

        (w1/w2).should be_between(0.95, 1.09)
        (neuron.umbral/w2).should be_between(-1.09, -0.90)
      end
    end

    describe "xor exercise" do
      it "all the value should be between (0.95, 1.09)" do
        csv_or = MyCsv::SpecialsCsv.new('xor.csv')

        neuron = Neuron.new(2, 0.5, 10, false)
        neuron.training(matrix(csv_or, 0.05, 20))

        pesos = neuron.w
        w1 =    neuron.w.first
        w2 =    neuron.w.last

        (w1/w2).should be_between(0.90, 1.1)
        (neuron.umbral/w2).should be_between(-1.1, -0.90)
      end
    end

    describe "Tabla 2.a exercise" do
      it "all the value should be between (0.95, 1.09)" do
        csv_tabla2 = MyCsv::SpecialsCsv.new('tabla2a.csv')

        neuron = Neuron.new(2, 0.5, 10, false)

        # asignamos nuestra matrixPruebas al objeto csv_tabla2
        csv_tabla2.matrix = matrix_2(csv_tabla2, 0.1, 124)
        porcentaje = 80
        cantidadParticiones = 5
        csv_tabla2.createIndices(porcentaje, cantidadParticiones)

        particiones = []
        for i in 0..cantidadParticiones-1 do
          neurona = Perceptron::Neuron.new(3, 0.2, 1,true)
          neurona.trainingWithIndices(csv_tabla2.matrix, csv_tabla2.trainingIndices[i])
          neurona.test(csv_tabla2.matrix, csv_tabla2.testIndices[i])
          particiones << neurona
        end

        sumaErrores = 0
        j = 0
        particiones.each do |epoca|
          sumaErrores += epoca.error
          j += 1
        end

        (sumaErrores * 100 / 1000).should be_between(18, 35)
      end
    end

    describe "Tabla 2.b exercise" do
      it "all the value should be between (0.95, 1.09)" do
        csv_tabla2 = MyCsv::SpecialsCsv.new('tabla2b.csv')

        neuron = Neuron.new(2, 0.5, 10, false)

        # asignamos nuestra matrixPruebas al objeto csv_tabla2
        csv_tabla2.matrix = matrix_3(csv_tabla2, 0.10, 624)
        porcentaje = 80
        cantidadParticiones = 50
        csv_tabla2.createIndices(porcentaje, cantidadParticiones)

        particiones = []
        for i in 0..49 do
          neurona = Perceptron::Neuron.new(3, 0.2, 1,true)
          neurona.trainingWithIndices(csv_tabla2.matrix, csv_tabla2.trainingIndices[i])
          neurona.test(csv_tabla2.matrix, csv_tabla2.testIndices[i])
          particiones << neurona
        end

        sumaErrores = 0
        particiones.each do |epoca|
          sumaErrores += epoca.error
        end

        (sumaErrores * 100 / 1000).should be_between(0, 1)
      end
    end
  end
end

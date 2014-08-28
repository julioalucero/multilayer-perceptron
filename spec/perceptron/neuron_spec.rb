require 'spec_helper'

module Perceptron
  describe Neuron do

    def matrix
      or_path = 'or.csv'
      csv_or = MyCsv::SpecialsCsv.new(or_path)

      desviacion = 0.05
      cantidad = 20
      matrixPrueba1 = MyRandom::SpecialsRandom.new(desviacion, cantidad, 1.0, 1.0,  nil, 1)
      matrixPrueba2 = MyRandom::SpecialsRandom.new(desviacion, cantidad, 1.0, -1.0, nil,  1)
      matrixPrueba3 = MyRandom::SpecialsRandom.new(desviacion, cantidad, -1.0, 1.0, nil,  1)
      matrixPrueba4 = MyRandom::SpecialsRandom.new(desviacion, cantidad, -1.0, -1.0,nil , -1)

      matrix = matrixPrueba3.matrix +  matrixPrueba2.matrix +
               matrixPrueba1.matrix +  matrixPrueba4.matrix +
               csv_or.matrix

      matrix.shuffle!
      matrix
    end

    describe "or exercise" do

      it "all the value should be between (0.95, 1.09)" do
        or_path = 'or.csv'
        csv_or = MyCsv::SpecialsCsv.new(or_path)

        neuron = Neuron.new(2, 0.5, 10, true)
        neuron.training(matrix)

        pesos = neuron.w
        w1 =    neuron.w.first
        w2 =    neuron.w.last

        (w1/w2).should be_between(0.95, 1.09)
        (neuron.umbral/w2).should be_between(-1.09, -0.90)
      end

    end
  end
end

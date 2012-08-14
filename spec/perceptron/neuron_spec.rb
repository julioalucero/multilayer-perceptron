require 'spec_helper'

module Perceptron
  describe Neuron do
    describe "#initialize_random" do
      it "all the value should be between [-0.5, 0.5]" do
        @neuron = Neuron.new(20, 0.5, 1, true)
        @neuron.w.each do |value|
          value.should be_between(-0.5, 0.5)
        end
      end
    end
  end
end

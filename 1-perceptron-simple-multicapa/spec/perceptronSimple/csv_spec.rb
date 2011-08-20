require 'spec_helper'

module PerceptorSimple
  describe Csv do
    describe '#to_integers' do
      context "when the file is correct open" do
        it "should get back and integers array" do
          csv = double('csv', :file_path => 'prueba.csv')
          csv.to_a
        end
      end
    end
  end
end

require 'spec_helper'

module MyRandom
  describe SpecialsRandom do
    describe "#initialize2d" do
      it "should create correct range numbers" do
        desviation = 0.2
        quantity = 2
        x = 1.0
        y = 1.0
        wish_output = 1
        @specials_random = SpecialsRandom.new(
          desviation, quantity, x, y,  nil, wish_output
        )
        @specials_random.matrix.each do |value|
          value[0].should be_between(0.8, 1.2)
          value[1].should be_between(0.8, 1.2)
        end
      end

      it "should create correct range numbers on negatives" do
        desviation = 0.2
        quantity = 5
        x = -1.0
        y = -1.0
        wish_output = 1
        @specials_random = SpecialsRandom.new(
          desviation, quantity, x, y,  nil, wish_output
        )
        @specials_random.matrix.each do |value|
          value[0].should be_between(-1.2, -0.8)
          value[1].should be_between(-1.2, -0.8)
        end
      end
    end

    describe "#initialize3d" do
      it "should create correct range numbers" do
        desviation = 0.2
        quantity = 2
        x = 1.0
        y = 1.0
        z = 1.0
        wish_output = 1
        @specials_random = SpecialsRandom.new(
          desviation, quantity, x, y, z, wish_output
        )
        @specials_random.matrix.each do |value|
          value[0].should be_between(0.8, 1.2)
          value[1].should be_between(0.8, 1.2)
          value[2].should be_between(0.8, 1.2)
        end
      end

      it "should create correct range numbers on negatives" do
        desviation = 0.2
        quantity = 5
        x = -1.0
        y = -1.0
        z = -1.0
        wish_output = 1
        @specials_random = SpecialsRandom.new(
          desviation, quantity, x, y, z, wish_output
        )
        @specials_random.matrix.each do |value|
          value[0].should be_between(-1.2, -0.8)
          value[1].should be_between(-1.2, -0.8)
          value[2].should be_between(-1.2, -0.8)
        end
      end
    end
  end
end

require 'spec_helper'

module MyRandom
  describe SpecialsRandom do
    describe "#say_hi" do
      it "say hi" do
        @specials_random = SpecialsRandom.new(0.3, 10, 1.0, 1.0,  nil, 1)
        p @specials_random
      end
    end
  end
end

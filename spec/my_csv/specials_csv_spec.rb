require 'spec_helper'

module MyCsv
  describe SpecialsCsv do
    describe "#to_a" do
      it "should convert to array the xor csv file" do
        csv_path = 'csv_test.csv'
        @specials_csv = SpecialsCsv.new(csv_path)
        @specials_csv.to_a.should == [[1.0, 1.0, -1.0]]
      end
    end
  end
end

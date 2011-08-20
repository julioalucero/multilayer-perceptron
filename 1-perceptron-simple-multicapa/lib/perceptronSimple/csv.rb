module PerceptorSimple
  class Csv
    attr_accessor :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def to_a
      array = IO.readlines(@file_path)
      matriz = to_integers(array)
    end

    def to_integers(array)
      matrix = Array.new
      array.each { |a|  matrix << a.split(',') }
      matrix.each { |s| s.collect! { |x| x.to_i } }
    end
  end
end

module PerceptorSimple
  class Csv
    attr_accessor :file_path, :matrix

    def initialize(file_path)
      @file_path = file_path
      @matrix = to_a
    end

    def to_a
      array = IO.readlines(@file_path)
      @matrix = to_integers(array)
    end

    def to_integers(array)
      matrizAuxiliar = Array.new
      array.each { |a|  matrizAuxiliar << a.split(',') }
      matrizAuxiliar.each { |s| s.collect! { |x| x.to_i } }
    end
  end
end

module Fam
  class Fuzzy
    attr_accessor :tiempo, :puertaAbierta, :tempRef
    attr_accessor :tempExt, :tempInt,:voltaje, :amperes
    attr_accessor :conjuntoEntrada

    #entradas es un vector de temperaturas que varia de 10 a 12º como para empezar
    #tiempo es en segundos
    #el amperaje da calor
    #el voltaje refresca la vida


    # conjuntoEntrada es una matriz donde cada fila representa las temperaturas
    # Muy Bajas - Baja - Normal - Alta - Muy Alta
    def initialize(tiempo)
      @tiempo = tiempo
      @puertaAbierta = false
      @tempRef = crear_temperatura_referencia
      @tempInt = []
      # @conjuntoEntrada = [[1.0, 0.25, 0.0, 0.0, 0.0, 0.0], [0.25, 1.0, 0.25, 0.0, 0.0, 0.0] , [0, 0.1, 1, 0.1, 0.0, 0.0], [0.0, 0.0, 0.25, 1.0, 0.25, 0.0], [0.0, 0.0, 0.0, 0.25, 1.0, 0.25] ]
      @conjuntoEntrada = [[0.0, 15.0, 10.0],[10.0, 20.0, 15.0], [18.0, 22.0, 20.0], [20.0, 30.0, 25.0], [25.0, 40.0, 30.0]]
    end

    def resolver
     # @tiempo.times do |t|
     #  if t % 3600 == 0 then
     #    @puertaAbierta == true
     #  end
       fuzzyfication(15)
       # codification
       # composition
       # defuzzzyfication
  #    end
    end

    def temperaturaExterna(tiempo) # nos dice la temperatura en un instante dado
      @tempExt = 10.0 + (2.0/ @tiempo) * tiempo
    end

    def crear_temperatura_referencia
      t1=Array.new(600,20)
      t2=Array.new(600,22)
      @tempRef =[]
      @tempRef << t1 << t2 << t1 << t2 << t1 << t2
      @tempRef.flatten
    end

    def tempInterior(t)
      if(@puertaAbierta)
        @tempInt << 0.169 * @tempInt[t-1] + 0.831 * @tempExt + 0.112 * (@amperes**2.0) - 0.002*@voltaje
      else
        @tempInt << 0.912 * @tempInt[t-1] + 0.088 * @tempExt + 0.604 * (@amperes**2.0) - 0.0121*@voltaje
      end
    end

    def fuzzyfication(t)
      temperaturaExterna(t)
      grados = []
      @conjuntoEntrada.each do |coord|
        grados << pertenencia(coord[0], coord[1], coord[2], t)
      end
      grados
    end

    def pertenencia(a, b, c, x)
      if x >= a  &&  x <= c then
        0.25 + (0.75 / (c-a)) * (x - a)
      elsif x > c && x <= b then
        1.0 - (0.75 / (b-c)) * (x-c)
      else
        0
      end
    end
  end
end

module RbfSom
  class Rbf
    attr_accessor :k, :patrones, :centroides

    def initialize(k, patrones)
      @k = k
      @patrones = []
      @centroides = []
      inicializarConjuntos(patrones)
      calcularCentroides
    end

    def inicializarConjuntos(patrones)
      patrones.each do | patron |
        @patrones << { :patron => patron, :clase => rand(@k) }
      end
    end

    def calcularCentroides
      conjunto = []
      @k.times do |i|
        conjunto = getConjunto(i)
        @centroides << media(conjunto)
      end
    end

    def getConjunto(k)
      conjunto = []
      @patrones.each do | patron |
        conjunto << patron[:patron] if patron[:clase] == k
      end
      conjunto
    end
#    def entrenar
#      medias = calcularMedias
#    end
#
    # Luego va a tener q ser más generico, para n dimensiones
    def media(conjunto)
      x = 0.0
      y = 0.0
      conjunto.each do  |patron|
        x += patron.first
        y += patron[1]
      end
      [x/conjunto.length, y/conjunto.length]
    end

    def normaEuc(patron, centroide)
      suma=0
      for i in 0...patron.length
        suma += patron[i]-centroide[i]
      end
      suma**2
    end

  end
end

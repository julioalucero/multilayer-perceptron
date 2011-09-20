module RbfSom
  class Rbf
    attr_accessor :k, :patrones, :centroides, :reasignaciones

    def initialize(k, patrones)
      @k = k
      @patrones = []
      @centroides = []
      @reasignaciones = true
      inicializarConjuntos(patrones)
    end

    def inicializarConjuntos(patrones)
      patrones.each do | patron |
        @patrones << { :patron => patron, :clase => rand(@k) }
      end
    end

    def entrenar
      suma = 0
      while @reasignaciones
        @reasignaciones = false
        calcularCentroides
        reasignar
      end
    end

    def calcularCentroides
      conjunto = []
      @centroides = []
      @k.times do |i|
        conjunto = getConjunto(i)
        @centroides << media(conjunto)
      end
    end

    def reasignar
      @patrones.each do | patron |
        clase = patron[:clase]
        patron[:clase] = min_norma_euclidea(patron[:patron])
        @reasignaciones = true if  clase != patron[:clase]
      end
    end

    def getConjunto(k)
      conjunto = []
      @patrones.each do | patron |
        conjunto << patron[:patron] if patron[:clase] == k
      end
      conjunto
    end

    # Luego va a tener q ser más generico, para n dimensiones
    def media(conjunto)
      x = 0.0
      y = 0.0
      conjunto.each do  |patron|
        x += patron[0]
        y += patron[1]
      end
      [(x/conjunto.count), (y/conjunto.count)]
    end

    # TODO luego debería hacerlo para n
    def min_norma_euclidea(patron)
      distancias = []
      @centroides.each do |centroide|
        #TODO llamar a funcion norma_eclidea
        distancias << ((patron[0] - centroide[0])**2) + ((patron[1] - centroide[1])**2)
      end
      distancias.index(distancias.min)
    end
  end
end

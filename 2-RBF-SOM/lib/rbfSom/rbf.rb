module RbfSom
  class Rbf
    attr_accessor :k, :patrones, :centroides, :desviacion, :reasignaciones, :first
    attr_accessor :pesosSalida, :salidaOculta, :salida, :neuronas ,:umbrales, :nu
    attr_accessor :errores

    def initialize(k, patrones, neuronas, nu)
      @k = k
      @patrones = []
      @centroides = []
      @nu = nu
      @reasignaciones = true
      @first = true
      @neuronas = neuronas
      @pesosSalida = []
      @umbrales = []
      inicializarConjuntos(patrones)
      @errores = 0
      inicializar_pesos
    end

    def inicializarConjuntos(patrones)
      patrones.each do | patron |
        @patrones << { :patron => patron, :clase => rand(@k) }
      end
    end

    def inicializar_pesos
      for i in 0...@neuronas.last
        aux = []
        for j in 0...@neuronas.first
          aux << 2 * 0.05 * rand - 0.05
        end
        @pesosSalida << aux
        @umbrales << 2*0.05*rand-0.05
      end
    end

    def calcular_centroides
      suma = 0
      while @reasignaciones
        @reasignaciones = false
        calcularCentroides
        reasignar
      end
      #calcular_desviacion
    end

    def calcularCentroides
      conjunto = []
      @centroides = []
      if first then
        patron = @patrones[rand(@patrones.length)][:patron]
        @centroides << patron[0...-1]
        contador = 1
        while contador != @k
          patron = @patrones[rand(@patrones.length)][:patron]
          if esta_lejos?(patron) then
             @centroides << patron[0...-1]
             contador += 1
          end
        end
        first = false
      else
        @k.times do |i|
          conjunto = getConjunto(i)
          @centroides << media(conjunto)
        end
      end
    end

    def entrenar
      @patrones.each do | patron |
        calcular_salida_intermedias(patron[:patron][0...-1])
        calcular_salida
        actualizar_pesos(patron[:patron].last)
      end
    end

    def test(patrones)
      patrones.each do | patron |
        calcular_salida_intermedias(patron[0...-1])
        calcular_salida
        if ( @salida[0].round(0) - patron.last > 0)
          @errores += 1
        end
      end
    end

    def calcular_salida_intermedias(patron)
      auxiliar = []
      @k.times do |i|
        auxiliar << func_gausiana(dist_euclidea(patron, @centroides[i]))
      end
      @salidaOculta = auxiliar
    end

    def func_gausiana(r)
     Math.exp(-(r**2)/2)
    end

    def calcular_salida
      y = []
      for i in 0...@neuronas.last
        sum=0.0
        for j in 0...@salidaOculta.count
          sum +=  @pesosSalida[i][j] * @salidaOculta[j]
        end
        sum += @umbrales[i]
        y << sum
      end
      @salida = y
    end

    def actualizar_pesos(yd)
      for i in 0...@pesosSalida.count
        for j in 0...@pesosSalida[0].count
          # TODO hacerlo para más salidas
          @pesosSalida[i][j] += -@nu * (@salida[i] - yd ) * @salidaOculta[j]
        end
        @umbrales[i] += - @nu * (@salida[i] - yd )
      end
    end


    def esta_lejos?(patron)
      distancias = norma_euclidea(patron)
      if distancias.min < 0.5 then
        false
      else
        true
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

    def norma_euclidea(patron)
      distancias = []
      @centroides.each do |centroide|
        #TODO llamar a funcion norma_eclidea
        distancias << ((patron[0] - centroide[0])**2) + ((patron[1] - centroide[1])**2)
      end
      distancias
    end

    def dist_euclidea(patron, centroide)
      suma = 0.0
      patron.each_index { |i| suma += (patron[i] - centroide[i])**2.0}
      Math.sqrt(suma)
    end

    def activacion(r)
      exp(-(r**2)/2)
    end

    def calcular_desviacion
      conjunto = []
      @desviacion = []
      @k.times do |i|
        conjunto = getConjunto(i)
        @desviacion << desviacion(conjunto, i)
      end
    end

    def desviacion(conjunto, i)
      x = 0.0
      y = 0.0
      conjunto.each do  |patron|
        x += (patron[0] - @centroides[i].first)**2.0
        y += (patron[1] - @centroides[i].last)**2.0
      end
      n = conjunto.count
      x = x/n
      y = y/n
      Math.sqrt(x**2 + y**2)
    end
  end
end

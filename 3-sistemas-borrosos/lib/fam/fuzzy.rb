module Fam
  class Fuzzy
	attr_accessor :tiempo, :puertaAbierta, :tempRef 
	attr_accessor :tempExt, :tempInt,:voltaje, :amperes
	
	#entradas es un vector de temperaturas que varia de 10 a 12º como para empezar
	#tiempo es en segundos
	#el amperaje da calor
	#el voltaje refresca la vida


  def initialize(tiempo)
    @tiempo = tiempo
    @puertaAbierta = false
    @tempRef = crear_temperatura_referencia
    @tempInt = [] 
    #@tempExt 
  end

  def resolver
    @tiempo.times do
     if @tiempo % 3600 == 0 then @puertaAbierta == true
     end
     fuzzyfication
     codification
     composition
     defuzzzyfication
    end
  end

  def temperaturaExterna(tiempo)    #nos dice la temperatura en un instante dado
    @tempExt = 10.0 + (2.0/@tiempo) *tiempo
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
	@tempInt << 0.169*@tempInt[t-1] + 0.831 *@tempExt + 0.112* (@amperes**2.0) - 0.002*@voltaje
      else
	@tempInt << 0.912*@tempInt[t-1] + 0.088 *@tempExt + 0.604* (@amperes**2.0) - 0.0121*@voltaje
    end
    end






    def fuzzyfication
    
    end
    
  end
end

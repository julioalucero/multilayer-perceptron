module Bayes
	class MailConverter
		attr_accessor :vectorMail, :file_path

		def initialize(file_path)
			@file_path = file_path
			@vectorMail = convert
		end


		def convert
			v = []
			array = IO.readlines(@file_path)
			array.each do |linea|
			v << linea.split()
			end
			v.flatten!
			v.delete("[]")
			v
		end
	end
end


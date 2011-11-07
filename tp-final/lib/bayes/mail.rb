module Bayes
class Email
    		attr_accessor :name, :from, :to, :subject, :urls
		def initialize(p)
				@name = p
        fc = IO.read(p)
        hdr = fc.split(/^\s*$/)[0]
        body = fc.sub(".{" + hdr.size.to_s + ",}",'')
        @from = /^From: (.+$)/.match(hdr).to_a[0]
        @to = /^To: (.+$)/.match(hdr).to_a[0]
        @subject = /^Subject: (.+$)/.match(hdr).to_a[0]
        @urls = /https?:\/\/.{1,}[\/]/.match(body).to_a.join(' ')
    end
    
    def Show
        puts @name + "\n\t" +
            @to +  "\n\t" +
            @from +  "\n\t" +
            @subject +  "\n\t" +
            @urls
    end
end

#Dir['*.eml'].each{|p|
#
#    e = Email.new(p)
#    e.Show
#}
end


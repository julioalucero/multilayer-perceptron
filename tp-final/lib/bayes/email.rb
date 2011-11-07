module Bayes
  class Email
    attr_accessor :name, :from, :to, :subject, :body, :spam

    def initialize(p)
      @name = p
      fc = IO.read(p)
      hdr = fc.split(/^\s*$/)[0]
      body = fc.sub(".{" + hdr.size.to_s + ",}",'')
      @from = /^From: (.+$)/.match(hdr).to_a[0]
      @to = /^To: (.+$)/.match(hdr).to_a[0]
      @subject = /^Subject: (.+$)/.match(hdr).to_a[0]
      @body = filter(get_body(body.split, '(UTC)'))
      @spam = spam?
    end

    def get_body(body, point_of_body)
      content = []
      body.reverse!
      body.each do |word|
        break if point_of_body == word
        content << word
      end
      content.reverse!
    end

    def filter(body)
      content = []
      body.each do |word|
        content << word if word.length >= 4 and word.length <= 12
      end
      content
    end

    def spam?
      spam = SPAM_HASH[@name]
      spam == "0" ? true : false
    end

    def show
      puts @name      + "\n\t" +
           @to        +  "\n\t" +
           @from      +  "\n\t" +
           @subject   +  "\n\t" +
           @body.to_s + "\n\t" +
           @spam      + "\n\t"
    end

    def get_hash
      email = {
        :to      => self.to,
        :from    => self.from,
        :subject => self.subject,
        :body    => self.body,
        :spam    => self.spam
      }
    end
  end

#Dir['*.eml'].each{|p|
#
#    e = Email.new(p)
#    e.Show
#}
end


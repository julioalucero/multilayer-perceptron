# encoding: ISO-8859-15

module Bayes
  class Email
    attr_accessor :id, :name, :from, :to, :subject, :body, :spam

    def initialize(p, id=nil)
      @id = id
      @name = File.basename(p)
      fc = IO.read(p)
      fc = fc.force_encoding("ISO-8859-15")
      hdr = fc.split(/^\s*$/)[0]
      body = fc.sub(".{" + hdr.size.to_s + ",}",'')
      @from = /^From: (.+$)/.match(hdr).to_a[0]
      @to = /^To: (.+$)/.match(hdr).to_a[0]
      @subject = /^[Subject: ](.*)/.match(hdr).to_a[0].split
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
#        content << word if word.length >= 4 and word.length <= 12
        content << word.downcase if permited?(word.downcase)
      end
      content
    end

    def permited?(word)
      return false if word.length <= 4 or word.length >= 12
      return false if !!word.match(/.[^a-z]/)
      true
    end

    def spam?
      spam = SPAM_HASH[@name]
      spam == "0" ? true : false
    end

    def show
      puts [name, to, from, subject, body.to_s, spam].join("\n\t") + "\n\t"
    end

    def get_hash
      p @subject
      @subject = filter(@subject)
      email = {
        to:      to,
        from:    from,
        subject: subject,
        body:    body,
        spam:    spam
      }
    end
  end
#Dir['*.eml'].each{|p|
#
#    e = Email.new(p)
#    e.Show
#}
end

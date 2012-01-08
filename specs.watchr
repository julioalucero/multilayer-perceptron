# begin; require 'watchr/event_handlers/em'; rescue LoadError; end

# Run me with:
#
#   $ watchr specs.watchr

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------
def all_spec_files
  Dir['spec/**/*_spec.rb']
end

def run_spec_matching(thing_to_match)
  matches = all_spec_files.grep(/#{thing_to_match}/i)
  if matches.empty?
    puts "Sorry, thanks for playing, but there were no matches for #{thing_to_match}"  
  else
    run matches.join(' ')
  end
end

def run(files_to_run)
  puts("Running: #{files_to_run}")
  system("clear")
  result = `ruby -Ilib \`which rspec\` --tty -c #{files_to_run}`
  puts result
  notify(result.gsub(%r{\e\[\d+m}, '').split("\n").last)
  no_int_for_you
end


def run_all_specs
  run(all_spec_files.join(' '))
end

def notify(summary)
  return if summary.nil?

  color = :green
  color = :yellow if summary.match(/pending/)
  color = :red if summary.match(/(\d+) failure/).captures.first.to_i > 0

  images = {
    :green  => '/home/julio/Imágenes/ruby-green.png',
    :yellow => '/home/julio/Imágenes/ruby-yellow.png',
    :red    => '/home/julio/Imágenes/ruby-red.png'
  }

  cmd = %W(
    notify-send
    --hint=string:x-canonical-private-synchronous:
    --hint=string:x-canonical-private-icon-only:
    --icon=#{images[color]}
    '#{color.to_s.upcase}'
  ).join(' ')
  system(cmd)
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch('^spec/(.*)_spec\.rb')   { |m| run_spec_matching(m[1]) }
watch('^lib/(.*)\.rb')         { |m| run_spec_matching(m[1]) }
watch('^spec/spec_helper\.rb') { run_all_specs }
watch('^spec/support/.*\.rb')  { run_all_specs }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
def no_int_for_you
  @sent_an_int = nil
end

Signal.trap 'INT' do
  if @sent_an_int then      
    puts "   A second INT?  Ok, I get the message.  Shutting down now."
    exit
  else
    puts "   Did you just send me an INT? Ugh.  I'll quit for real if you do it again."
    @sent_an_int = true
    Kernel.sleep 1.5
    run_all_specs
  end
end

# vim:ft=ruby

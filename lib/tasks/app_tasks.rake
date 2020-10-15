desc 'Fire irb console'
task :console do
  require_relative '../../application.rb'
  require 'irb'
  ARGV.clear
  IRB.start
end

task c: :console

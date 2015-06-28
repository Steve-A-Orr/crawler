require 'benchmark'
require_relative 'lib/crawler'
require_relative 'lib/core_ext/string'

modules = ARGV[0].split(',') rescue []

if modules.size == 0
  puts "!!! Missing module list !!!".red
  exit(1)
end

c = Crawler::Main.new(modules)

real = Benchmark.measure { c.run }.real
puts "---- Time taken total: #{"%0.2f" % real}s".blue

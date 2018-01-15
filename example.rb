require 'benchmark'
require 'coverage'

WITH_COVERAGE = !!ENV['COVERAGE']
WITH_ENHANCED_COVERAGE = !!ENV['ENHANCED_COVERAGE']

Coverage.start if WITH_COVERAGE || WITH_ENHANCED_COVERAGE
require 'bigdecimal/math'
require './app'
require './app_proxy'
Coverage.pause if WITH_ENHANCED_COVERAGE

ITERATIONS = 2_000
UPTO = 1_000
coverage_data = nil

# warm up
AppProxy.process(App, {iterations: 1, up_to: UPTO})

Benchmark.bm do |bm|
  if WITH_ENHANCED_COVERAGE
    bm.report { coverage_data = AppProxy.process(App, {iterations: ITERATIONS, up_to: UPTO, coverage: false, enhanced_coverage: false}) }
  end
  bm.report { coverage_data = AppProxy.process(App, {iterations: ITERATIONS, up_to: UPTO, coverage: WITH_COVERAGE, enhanced_coverage: WITH_ENHANCED_COVERAGE}) }
end

puts "coverage"
puts coverage_data
puts "done"

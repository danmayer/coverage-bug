def method_a
  puts "method_a called"
end
 
def method_b
  puts "method_b_called"
end

method_a
puts Coverage.result
 
puts "this doesn't matter and is between coverage"
 
Coverage.start
method_b
puts Coverage.result

### output
# method_a called
# {"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[1, 1, nil, nil, 1, 0, nil, nil, 1, 1, nil, 0, nil, 0, 0, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil]}
# this doesn't matter and is between coverage
# method_b_called
# {"/Users/danmayer/projects/coverage-bug/covercheck.rb"=>[]}
#
# I would expect after the second coverage.start and calling new lines in the file by calling ethod B to have those lines output as part of the 2nd Coverage.result call.

def method_a
  puts "method_a called"
end
 
def method_b
  puts "method_b_called"
end

method_a

puts Coverage.pause
puts Coverage.peek_result
puts Coverage.reset
 
puts "this line is run betwwen coverage being enabled and shouldn't get tracked"
 
Coverage.resume
method_b
puts Coverage.result

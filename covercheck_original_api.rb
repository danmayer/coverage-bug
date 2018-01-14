def method_a
  puts "method_a called"
end
 
def method_b
  puts "method_b_called"
end

method_a
puts Coverage.result
 
puts "this line is run between coverage being enabled and shouldn't get tracked"
 
Coverage.start
method_b
puts Coverage.result

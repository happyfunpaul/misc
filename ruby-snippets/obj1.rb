#!/usr/bin/env ruby

class Car
	@engine = "yes"
	@started = "no"
	
	def start
		puts "Okay, started the car."
		@started = "yes"
	end
end

c = Car.new()
5.times do |ln|
	print ln
	print ": "
	c.start
end


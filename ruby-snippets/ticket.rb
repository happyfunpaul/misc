#!/usr/bin/env ruby

class Event_Ticket 
	attr_accessor :date, :venue, :event, :performer, :seat, :price
	def initialize(date,venue,event,performer,seat,price)
		@date=date || @date="01/01/1970"
		@venue=venue
		@event=event
		@performer=performer
		@seat=seat
		@price="%.2f" % price
	end
end

ticket=Event_Ticket.new("03/03/2015","Radio City Music Hall","Axl Rose Comeback Tour","Axl Rose","Sec 104, Row 3, Seat 7", "205.00")

#puts "This ticket is for: #{ticket.event} at #{ticket.venue}, " +
#	"on #{ticket.date}. " +
#	"The performer is #{ticket.performer}. " +
#	"The seat is #{ticket.seat} and it costs $" +
#	"#{"%.2f." % ticket.price}"
#

puts "What would you like to know about this ticket?"
req = gets.chomp

if ticket.respond_to?(req) 
	# "send" or "__send__" works. The latter is safer (never overriden, by convention.)
	puts ticket.__send__(req) 
else
	puts "U wot m8?"
end


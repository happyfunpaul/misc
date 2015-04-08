#!/usr/bin/env ruby

iter = ARGV[0].to_i
unless iter > 0
	puts "This script takes one argument: the index of the Fibonacci sequence to calculate."
	exit
end

def fib(n)
	n < 2 ? 1 : fib(n-1) + fib(n-2)
end


class FibCache
	def initialize()
		@ourcache = Array.new
	end
	
	def get(index)
		if @ourcache[index].to_i > 0 
			return @ourcache[index]
		else return nil
		end
	end	

	def set(index, val)
		if val > 0
			@ourcache[index] = val.to_i and return true
		else
			return false
		end
	end
end


def fibcache(n)

	return 1 if n < 2	
	
	cacheval = $fc.get(n).to_i
	if cacheval > 0
		return cacheval 
	else
		cacheval = fibcache(n-1) + fibcache(n-2)
		$fc.set(n,cacheval)
		return cacheval
	end
end

$fc = FibCache.new
print fibcache(iter).to_s + "\n"

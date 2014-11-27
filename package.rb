require 'yaml'
class Package
	
	DEFAULTS = {
		:pname => nil,
		:deps  => nil,
		:arch  => nil,
		:filelist => nil,
	}

	def initialize(*args)
		@data = if args.size == 0
					DEFAULTS
				else
					args[0]
				end
	end

	def longname

	end

	def dump
		YAML::dump(@data)
	end

	# if we try to access anything that's in data, automatically
	# return its value or assign to it
	def method_missing(method, *args, &blokc)
		entry = method
		/(.*)=$/.match(method) do |match|
			# this is an assignment (got :symbol=)
			entry = match[1].to_sym
		end
		if @data.include?(entry)
			if method == entry
				# just return the value
				@data[entry]
			else
				fail "need exactly 1 argument in assignment" if args.size != 1
				# assign the value
				@data[entry] = args[0]
			end
		else
			# the data hash doesn't include this
			# key, that's an error
			super
		end
	end
end

p = Package.new
puts p.pname
p.pname = "test"
puts p.pname


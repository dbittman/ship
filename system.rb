# System defines a system on which packages may be installed.
# It specifies a path to that system (local or remote), the
# root of where to install packages, and the databases for that
# system. Also includes system information, such as architecture.
require_relative 'package.rb'
require_relative 'manifest.rb'
class System
	def initialize(systemfile)
		@database = Manifest.new(systemfile)
	end
	
	def method_missing(method, *args, &block)
		entry = method
		/(.*)=$/.match(method) do |match|
			# this is an assignment (got :symbol=)
			entry = match[1].to_sym
		end
		if(entry == method)
			@database.read("system", method.to_s)
		else
			@database.write_field("system", method.to_s, args[0])
		end
	end

	def add_package(pack)
		@database.write_field("packages", pack.pname, pack.getdata)
	end

	def del_package(pack)
		@database.delete("packages", pack.pname)
	end

	def get_package(name)
		hash = @database.read("packages", name)
		hash.nil? ? nil : Package.new(hash)
	end

end


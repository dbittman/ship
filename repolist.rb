require_relative 'manifest.rb'
class Repolist
	def initialize(filename)
		@database = Manifest.new(filename)
	end

	# returns a System,Package object
	def search(pname)
		@database.read("systems").each_value do |sysfile|
			sys = System.new(sysfile)
			package = sys.get_package(pname)
			return sys if !package.nil?
		end
		nil
	end
	
	def add(name, filename)
		@database.write_field("systems", name, filename)
	end
	
	def delete(name)
		@database.delete("systems", name)
	end
end


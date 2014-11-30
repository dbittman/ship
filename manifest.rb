# Manifest defines a file that contains a list of packages. This
# is accessed as a YAML store, with various key-values:
#	- list of packages
#	- packages location
require 'yaml/store'

class Manifest

	def initialize(filename)
		@store = YAML::Store.new(filename)
	end
	
	def clear
		@store.transaction do
			@store.clear
		end
	end

	def write_field(category, name, data)
		@store.transaction do
			@store[category] ||= {}
			@store[category][name] = data
		end
	end

	def write_table(category, data)
		@store.transaction do
			@store[category] = data
		end
	end

	def delete(category, name)
		@store.transaction do
			@store[category].nil? || @store[category].delete(name)
		end
	end
	
	def read(category, name = nil)
		@store.transaction(true) do
			if name.nil? || @store[category].nil?
				@store[category]
			else
				@store[category][name]
			end
		end
	end
end


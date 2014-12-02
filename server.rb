require 'socket'
require 'yaml'
require_relative 'package.rb'
class Server
	def initialize
		@socket = TCPServer.open(2000)
		puts "created new ship server #{@socket}"
		@listener = nil
	end

	def communicate(client)
		data = ""
		loop {
			tmp = client.recv(128)
			data += tmp
			break if tmp.include?("...")
		}
		cmd = YAML::load(data)
		case cmd["command"]
			when "recvpack"
				system = System.new(Repolist.new("systems.yml").get(cmd["system"]))
				package = Package.new(cmd["package"])
				system.install(package)
			when "querypack"

			when "querypacks"
			
			when "querysystem"
				system = System.new(Repolist.new("systems.yml").get(cmd["system"]))
				client.write(system.to_hash.to_yaml)
				client.write("...")
			when "querysystems"
				client.write(Repolist.new("systems.yml").list.to_yaml)
				client.write("...")
		end
	end

	def listen_connections
		puts "ship server listening"
		@listener = Thread.new do
			Thread.start(@socket.accept) do |client|
				puts "accepting connection from #{client}"

				communicate(client)

				client.close
			end
		end
	end
	
	def shutdown
		puts "shutting down server"
		@listener.exit
		@socket.shutdown
	end

end


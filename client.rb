require 'yaml'

class Client
	def initialize(server_addr)
		@server = TCPSocket.open(server_addr, 2000)
		puts "client connected to server"
	end

	def send_hash(hash)
		@server.write(hash.to_yaml)
		@server.write("...")
	end
	
	def get_hash
		data = ""
		loop {
			tmp = @server.recv(128)
			data += tmp
			break if tmp.include?("...")
		}
		YAML::load(data)
	end

	def disconnect
		@server.shutdown
	end

end


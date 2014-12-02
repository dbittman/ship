require_relative 'manifest.rb'
require_relative 'package.rb'
require_relative 'system.rb'
require_relative 'repolist.rb'
require_relative 'server.rb'
require_relative 'client.rb'
require 'thread'
Thread.abort_on_exception = true

s = Server.new
s.listen_connections
sleep 0.3
c = Client.new("localhost")
sleep 0.3

cmd = {
	"command" => "recvpack",
	"system"  => "core",
	"package" => {
		:pname => "gcc",
		:version => "4.8",
		:revision => "1",
		:arch => "x86_64"
	}
}

cmd2 = {
	"command" => "querysystems",
	"system"  => "core"
}

c.send_hash(cmd2)
h = c.get_hash

puts h

c.disconnect

loop{}


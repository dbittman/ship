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
	"command" => "querysystem",
	"system"  => "core"
}

c.send_hash(cmd2)
h = c.get_hash

puts h

p "getting package"

sys = System.new("localhost-core.yml")
sys.merge(h)
pack = sys.get_package("gcc")
puts pack.dump

puts

puts pack.resolve_location("localhost", sys)

c.disconnect

loop{}


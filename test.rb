require_relative 'manifest.rb'
require_relative 'package.rb'
require_relative 'system.rb'
require_relative 'repolist.rb'

r = Repolist.new("repos.yaml")
r.add("core", "core.yaml")
r.search("gcc")


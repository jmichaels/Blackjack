# Require gems
require 'active_support'
require 'highline'

# Require all files
Dir["./models/*.rb"].each {|file| require file }

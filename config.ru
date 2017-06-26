$LOAD_PATH << File.expand_path("../lib", __FILE__)

require "app"

run ExampleApp
$stdout.sync = true

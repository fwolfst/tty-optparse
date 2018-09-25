#!/usr/bin/env ruby

require 'optparse'
require 'tty-config'

VERSION='0.0.1'

options = {}

option_parser = OptionParser.new do |opts|
  opts.banner = <<~USAGE
    Usage: #{$PROGRAM_NAME} [options]
    Consume options and inspect tty-config usage
  USAGE

  opts.separator ["", "Connection parameter"]
  opts.on("-h", "--host HOSTNAME_OR_IP", "Hostname or IP Adress") do |h|
    options[:host] = h
  end
  opts.on("-p", "--port PORT", "Port of application", Integer) do |p|
    options[:port] = p
  end
  opts.on("-u", "--user USERNAME", "Username (defaults to 'user')") do |u|
    options[:user] = u
  end

  opts.separator ["", "Common options"]
  opts.on("-c", "--config FILE",
					"Read config values from file (defaults: ./config.yml, ~/.config.yml") do |c|
    options[:config_file_path] = c
  end
  opts.on_tail("-h", "--help", "Show this message and exit") do
    puts opts
    exit
  end
  opts.on_tail("--version", "Show version and exit") do
    puts VERSION
    exit
  end
end

# Process command line options
option_parser.parse!

config = TTY::Config.new
config_filename = options[:config_file_path] || 'config.yml'

if !options[:config_file_path]
  config.append_path Dir.pwd
  config.append_path Dir.home
end

begin
	print "Attempting to read from configuration file #{config_filename}"
	config.read config_filename
	puts " ... fine."
rescue TTY::Config::ReadError => read_error
	STDERR.puts "\nNo configuration file found:"
	STDERR.puts read_error
end

# Merge options passed by arguments (--host) with those from file
config.merge(options)

# Validation
if !config.fetch(:host) || !config.fetch(:port)
	STDERR.puts "Host and port have to be specified (call with --help for help)."
	exit 1
end

# Execution
puts "Connect to %s@%s:%d" % [
	config.fetch(:user, default: 'user'),
	config.fetch(:host),
	config.fetch(:port)]

exit 0

#!/usr/bin/ruby

require 'rsync'
require 'yaml'

def backup(source, destination, args)
  Rsync.run(source, destination, args) do |result|
    if result.success?
      result.changes.each do |change|
        puts "#{change.filename} (#{change.summary})"
      end
    else
      puts result.error
    end
  end
end

server = YAML.load_file("servers/#{ARGV[0]}.yaml")

server['dirs'].each do |dir|
  backup("#{server['remote']}:#{dir['source']}", "#{server['destination']}/#{dir['destination']}", ['--archive', '--delete'])
end
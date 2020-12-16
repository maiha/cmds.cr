# lib
require "levenshtein"

# shards
require "pretty"
require "var"

# app
require "./cmds/navigatable"
require "./cmds/**"

module Cmds
  CMDS = Hash(String, Cmd.class).new

  PROGRAM = File.basename(PROGRAM_NAME)

  macro command(name)
    {% name_s = name.id.stringify %}
    class ::Cmds::{{name_s.gsub(/\./,"_").camelcase.id}}Cmd < ::Cmds::Cmd
      NAME = {{name_s}}
      ::Cmds.register({{name_s}}, self)

      include ::Cmds::Cmd::DefaultActions

      {{ yield }}
    end
  end

  def self.register(name, cmd)
    if klass = self[name]?
      STDERR.puts "warning: '%s' command has been changed from `%s` to `%s`" % [name, klass, cmd]
    end
    CMDS[name] = cmd
  end

  def self.names : Array(String)
    CMDS.keys.sort
  end
  
  def self.[](name)
    name = name.to_s
    if cmd = self[name]?
      return cmd
    elsif name.size > 0
      raise InvalidCommand.new(command: name)
    else
      raise MissingCommand.new
    end
  end  

  def self.[]?(name : String)
    CMDS[name]?
  end

  def self.run(args = ARGV)
    Cli::Default.run(args)
  end
end

# lib
require "levenshtein"

# shards
require "pretty"
require "var"

# app
require "./cmds/navigatable"
require "./cmds/cmd_table"
require "./cmds/**"

module Cmds
  PROGRAM = File.basename(PROGRAM_NAME)
  PROGRAM_CMD_TABLES = Hash(String, CmdTable).new

  @@single_binary_name : String =  File.basename(PROGRAM_NAME)
  def self.single_binary_name : String
    @@single_binary_name
  end

  def self.single_binary_name=(v)
    @@single_binary_name = v
  end

  macro command(name, group = nil)
    {% name_s = name.id.stringify %}
    class ::Cmds::{{name_s.gsub(/\./,"_").camelcase.id}}Cmd < ::Cmds::Cmd
      NAME = {{name_s}}
      ::Cmds.register(program: "", name: {{name_s}}, cmd: self)
      include ::Cmds::Cmd::DefaultActions

      {{ yield }}
    end
  end

  macro program_command(prog, name)
    {% prog_s = prog.id.stringify %}
    {% name_s = name.id.stringify %}
    class ::Cmds::{{prog_s.gsub(/-/,"_").gsub(/\./,"_").camelcase.id}}_{{name_s.gsub(/\./,"_").camelcase.id}}Cmd < ::Cmds::Cmd
      NAME = {{name_s}}
      ::Cmds.register(program: {{prog_s}}, name: {{name_s}}, cmd: self)
      include ::Cmds::Cmd::DefaultActions

      {{ yield }}
    end
  end

  def self.register(program : String, name : String, cmd) : CmdTable
    cmd_table = PROGRAM_CMD_TABLES[program] ||= CmdTable.new
    if klass = cmd_table[name]?
      STDERR.puts "warning: '%s' command has been changed from `%s` to `%s`" % [name, klass, cmd]
    end
    cmd_table[name] = cmd
    return cmd_table
  end

  def self.names : Array(String)
    cmd_table.keys.sort
  end

  def self.cmd_table : CmdTable
    if single_binary_name == PROGRAM
      program_cmd_table?(PROGRAM) || program_cmd_table?("") || CmdTable.new
    else
      program_cmd_table?(PROGRAM) || raise CmdNotFound.new(PROGRAM)
    end
  end

  def self.program_cmd_table?(name) : CmdTable?
    PROGRAM_CMD_TABLES[name.to_s]?
  end

  def self.program_cmd_table(name) : CmdTable
    program_cmd_table?(name) || raise CmdNotFound.new(name)
  end

  def self.[](name)
    cmd_table.resolve(name)
  end

  def self.[]?(name)
    cmd_table.resolve?(name)
  end

  def self.run(args = ARGV)
    Cli::Default.run(args)
  end
end

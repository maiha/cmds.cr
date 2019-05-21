module Cmds
  class Finished        < Exception; end
  class Abort           < Exception; end
  class ArgumentError   < Exception; end

  class CommandNotFound < Exception
    getter name : String
    getter possible : Array(String)

    def initialize(@name, @possible)
    end
    
    def to_s(io : IO)
      io <<
        if name.empty?
          "fatal: You must specify a command name.\n"
        else
          "fatal: '%s' is not a valid command name.\n" % [name]
        end
      io << "\n"
      io << "Usage: %s <<COMMAND>>\n" % [PROGRAM_NAME]
      if possible.any?
        io << "  %s\n" % possible.join(", ")
      end
    end
  end

  class TaskNotFound < Exception
    getter name : String
    getter cmd  : Cmd

    def initialize(@name, @cmd)
    end
    
    delegate cmd_name, task_names, pretty_usage, to: cmd.class

    def to_s(io : IO)
      io <<
        if name.empty?
          "fatal: You must specify a task name for the command '%s'.\n" % cmd_name
        else
          "fatal: '%s' is not a valid task name for the command '%s'.\n" % [name, cmd_name]
        end
      io << "\n"
      io << "Usage: %s %s <<TASK>>\n" % [PROGRAM_NAME, cmd_name]
      if task_names.any?
        io << "  %s\n" % task_names.join(", ")
      end
      if cmd.class.usages.any?
        io << "\n"
        io << "Examples:\n"
        io << pretty_usage(prefix: "  ")
      end
    end
  end

  class ArgumentNotFound < ArgumentError
    getter idx : Int32
    getter exp : Array(String)
    getter got : Array(String)

    def initialize(@idx, @exp, @got)
    end
    
    def usage : String
      lines = Array(Array(String)).new
      # expected
      lines << (["usage:"] + exp)
      # got
      lines << ([""] + got)
      # hint
      lines << ["", "", "", ""] + exp[3..-1].to_a.map_with_index{|v,i|
        if i == idx
          "^" * (exp[3+i]?.try(&.size) || 3)
        else
          ""
        end
      }

      # fill up to max element size
      max_element_size = lines.map(&.size).max
      lines.each do |ary|
        (max_element_size - ary.size).times do
          ary << ""
        end
      end
      
      usage = Pretty.lines(lines, delimiter: " ")
      return usage
    end

    def to_s(io : IO)
      io.puts usage
      io << "Arg#{idx+1} not found"
    end
  end

  class ArgumentNotValid < ArgumentError
    getter idx : Int32
    getter exp : Array(String)
    getter got : Array(String)
    getter err : Exception

    def initialize(@idx, @exp, @got, @err)
    end
    
    def usage : String
      lines = Array(Array(String)).new
      # expected
      lines << (["usage:"] + exp)
      # got
      lines << ([""] + got)
      # hint
      lines << ["", "", "", ""] + got[3..-1].to_a.map_with_index{|v,i|
        if i == idx
          "^" * (got[3+i]?.try(&.size) || 3)
        else
          ""
        end
      }

      # fill up to max element size
      max_element_size = lines.map(&.size).max
      lines.each do |ary|
        (max_element_size - ary.size).times do
          ary << ""
        end
      end
      
      usage = Pretty.lines(lines, delimiter: " ")
      return usage
    end

    def to_s(io : IO)
      io.puts usage
      io << @err.to_s
    end
  end
end

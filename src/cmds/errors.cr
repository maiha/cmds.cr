module Cmds
  klass Finished        < Exception
  klass Abort           < Exception
  klass ArgumentError   < Exception

  klass CommandNotFound < Exception, name : String, possible : Array(String) do
    def to_s(io : IO)
      io << "Error: unknown command: '#{name}'\n"
      io << "Possible commands are: #{possible}"
    end
  end

  klass TaskNotFound < Exception, name : String, cmd : Cmd do
    def to_s(io : IO)
      io << "Error: unknown task: '#{name}'\n"
      io << "Possible tasks are: #{cmd.class.task_names}\n"
      io << cmd.class.pretty_usage(prefix: "  ")
    end
  end
end

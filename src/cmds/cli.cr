abstract class Cmds::Cli
  macro inherited
    def self.run(args = nil)
      new.run(args || ARGV)
    end
  end

  class Default < Cmds::Cli
    def run(args)
      Cmds[args.shift?].run(args)
    rescue err : Cmds::Abort | Cmds::CommandNotFound | Cmds::TaskNotFound
      STDERR.puts err.to_s.colorize(:red)
      exit 1
    end
  end
end

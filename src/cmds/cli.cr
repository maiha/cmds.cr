abstract class Cmds::Cli
  macro inherited
    def self.run(args = ARGV)
      new.run(args)
    end
  end

  class Default < Cmds::Cli
    def run(args)
      Cmds[args.shift?].run(args)
    rescue Cmds::Finished
    rescue err : Cmds::Abort | Cmds::CommandNotFound | Cmds::TaskNotFound
      STDERR.puts err.to_s.chomp.colorize(:red)
      exit 1
    end
  end
end

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
    rescue err : Cmds::Navigatable
      STDERR.puts Cmds::Navigator.new.navigate(err)
      exit err.exit_code
    rescue err : Cmds::Abort
      STDERR.puts err.to_s.chomp.colorize(:red)
      exit 1
    end
  end
end

class Cmds::Cli
  def self.run(args = ARGV)    
    new.run(args)
  end

  def run(args)
    cmd = Cmds.cmd_table.resolve(args.shift?)
    cmd.run(args)
  rescue err
    handle_error(cmd, err)
  end

  def handle_error(cmd, err : Cmds::Finished)
  end

  def handle_error(cmd, err : Cmds::CmdNotFound)
    STDERR.puts "#{err}: command not found"
    exit 127
  end

  def handle_error(cmd, err : Cmds::Navigatable)
    STDERR.puts Cmds::Navigator.new.navigate(err)
    exit err.exit_code
  end

  def handle_error(cmd, err : Cmds::Abort)
    STDERR.puts err.to_s.chomp.colorize(:red)
    exit 1
  end

  # unhandled error
  def handle_error(cmd, err)
    STDERR.puts err.to_s.chomp.colorize(:red)
    msg = err.to_s.chomp
    if msg.empty?
      msg = String.build do |s|
        s << "#{err.class}"
        if trace = err.backtrace?
          s << "\n  #{trace.first}"
        end
      end
    end
    STDERR.puts msg.colorize(:red)
    exit 1
  end

  class Default < Cli
  end
end

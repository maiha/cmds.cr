require "../src/cmds"

Cmds.command "show" do
  desc "usage", "# invoke show_usage in cmd"
  task "usage" do
    show_usage
  end

  desc "usage_with_msg", "# invoke show_usage with msg in cmd"
  task "usage_with_msg" do
    show_usage("foo")
  end
end

class Main < Cmds::Cli
  def run(args)
    case args[0]?
    when "-h", "--help"
      raise Cmds::ShowUsage.new
    when "-V", "--version"
      puts "version: 0.1.0"
    else
      super
    end
  rescue err
    handle_error(cmd: nil, err: err)
  end
end

Main.run

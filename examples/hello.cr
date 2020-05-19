require "../src/cmds"

Cmds.command "world" do
  def run
    puts "Hello world!"
    puts args.inspect if args.any?
  end

  private def before
    puts "(before)"
  end

  private def after
    puts "(after)"
  end
end

Cmds.run

# ```console
# $ ./hello world
# (before)
# Hello world!
# (after)
# ```

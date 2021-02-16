require "../src/cmds"

Cmds.single_binary_name = "single-binary"

Cmds.program_command "one", "hello" do
  task "world" do
    puts "1"
  end
end

Cmds.program_command "two", "hello" do
  task "world" do
    puts "2"
  end
end

Cmds.program_command "three", "run" do
  desc "run", "# direct method"
  def run
    puts "run method"
  end
end

Cmds.run

# ```console
# $ ln -s single-binary one
# $ ln -s single-binary two
#
# $ ./one hello world
# 1
#
# $ ./two hello world
# 2
# ```

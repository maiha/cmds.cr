require "../src/cmds"

Cmds.command "math" do
  task "sum", "a b" do
    a = arg1(&.to_i)
    b = arg2(&.to_i)
    puts a + b
  end
end

Cmds.run

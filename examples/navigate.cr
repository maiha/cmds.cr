require "../src/cmds"

Cmds.command "web" do
  usage "# web server"

  desc "run", "0.0.0.0:8180 # run http server"
  task "run", "<bind>" do
    bind = arg1(msg: "Specify the address and port to listen.")
    puts "Listening on #{bind}"
  end

  desc "start", "0.0.0.0:8180 # start http server"
  task "start", "<bind>" do
  end

  desc "stop", "# stop http server"
  task "stop" do
  end
end

Cmds.command "calc" do
  task "sum", "<num1> <num2> # add num1 and num2" do
    num1 = arg1.to_i
    num2 = arg2.to_i
    puts "#{num1 + num2}"
  end
end

Cmds.command "todo" do
  usage "# manage TODO list"

  task "list" do
  end
end

Cmds.run

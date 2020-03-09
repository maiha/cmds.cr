require "../src/cmds"

Cmds.command "web" do
  desc "run", "0.0.0.0:8180 # run http server"
  task "run", "<bind>" do
    bind = arg1(msg: "Specify the address and port to listen.")
    puts "Listening on #{bind}"
  end
end

Cmds.run

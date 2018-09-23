require "../src/cmds"

require "json"

Cmds.command "json" do
  usage "pretty file.json"
  usage "fails"

  task "pretty" do
    path = args.shift? || abort "specify file"
    puts Pretty.json(File.read(path))
  end

  task "fails" do
    raise "unhandled error"
  end
end

Cmds.run(ARGV)

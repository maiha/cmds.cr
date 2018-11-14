require "../src/cmds"

require "json"

Cmds.command "json" do
  usage "pretty file.json"
  usage "fails"

  var task_name_in_before : String
  
  def before
    self.task_name_in_before = task_name
  end

  task "pretty" do
    path = args.shift? || abort "specify file"
    puts Pretty.json(File.read(path))
  end

  task "fails" do
    raise "unhandled error" % task_name_in_before
  end

  task "inspect" do
    puts "task_name(before)=#{task_name_in_before}"
    puts "task_name=#{task_name}"
    puts "args=#{args.inspect}"
  end
end

Cmds.run

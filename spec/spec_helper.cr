require "spec"
require "shell"

require "../src/cmds"

def run(arg) : Shell::Seq
  shell = Shell::Seq.new
  shell.run("./tmp/#{arg}")
  return shell
end

macro run!(arg)
  shell = run({{arg}})
  unless shell.success?
    msg = shell.stderr.split(/\n/)[0..3].join("\n")
    fail "(exit #{shell.exit_code}) {{arg.id}}\n#{msg}".strip
  end
  shell
end

def remove_ansi_color(buf : String) : String
  buf.gsub(/\e\[\d{1,3}[mK]/, "")
end

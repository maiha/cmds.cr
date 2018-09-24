require "spec"
require "shell"

require "../src/cmds"

def run(arg) : Shell::Seq
  shell = Shell::Seq.new
  shell.run("./tmp/#{arg}")
  return shell
end

def run!(arg) : Shell::Seq
  shell = run(arg)
  unless shell.success?
    msg = shell.stderr.split(/\n/)[0..2].join("\n")
    fail "(exit #{shell.exit_code}) #{arg}\n#{msg}".strip
  end
  shell
end

def remove_ansi_color(buf : String) : String
  buf.gsub(/\e\[\d{1,3}[mK]/, "")
end

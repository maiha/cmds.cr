require "spec"
require "shell"

require "../src/cmds"

def run?(cmd)
  shell = Shell::Seq.run(cmd)
  shell.success?
end

def run(cmd)
  shell = Shell::Seq.run(cmd)
  unless shell.success?
    msg = shell.stderr.split(/\n/)[0..2].join("\n")
    fail "(exit #{shell.exit_code}) #{cmd}\n#{msg}".strip
  end
  shell
end

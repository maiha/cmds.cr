require "../src/cmds"

Cmds.command "emulate" do
  task "success" do
    # successfully done
  end

  task "failure" do
    abort "An error has occurred"
  end

  task "finished" do
    finished!("Intentional normal termination")
  end

  private def after
    puts task_state
  end
end

Cmds.run

# ```console
# $ ./status emulate success
# FINISHED
#
# $ ./status emulate failure
# RUNNING
# An error has occurred
#
# $ ./status emulate finished
# FINISHED
# ```

module Cmds
  class Finished      < Exception; end
  class Abort         < Exception; end
  class ArgumentError < Exception; end
  
  class MissingCommand < Navigatable
    navigate <<-EOF
      usage: {program} <command> ...
             {program} ^^^^^^^^^

      commands:
        {commands}

      missing <command>.
      EOF
  end

  class InvalidCommand < Navigatable
    navigate <<-EOF
      usage: {program} <command> ...
             {program} {command}

      commands:
        {commands}

      invalid command: '{command}'
      EOF
  end

  class MissingTask < Navigatable
    navigate <<-EOF
      usage: {program} {command} <task> ...
             {program} {command} ^^^^^^

      tasks:
        {tasks}

      missing <task>.
      EOF
  end

  class InvalidTask < Navigatable
    navigate <<-EOF
      usage: {program} {command} <task> ...
             {program} {command} {task}

      tasks:
        {tasks}

      invalid task: '{task}'
      EOF
  end

  class MissingArgument < Navigatable
    navigate <<-EOF
      usage: {program} {command} {task} {args}
             {program} {command} {task} {argv}

      {examples}{msg}
      EOF
  end

  class InvalidArgument < Navigatable
    navigate <<-EOF
      usage: {program} {command} {task} {args}
             {program} {command} {task} {argv}

      {examples}{msg}
      EOF
  end
end

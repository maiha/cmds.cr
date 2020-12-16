module Cmds
  class Finished      < Exception; end
  class Abort         < Exception; end
  class ArgumentError < Exception; end
  
  class ShowUsage < Navigatable
    var exit_code : Int32 = 0

    navigate <<-EOF
      usage: {program} <command> ...

      commands:
          {commands}

      examples:
      {commands_usages}

      {msg}
      EOF
  end

  class ShowUsageWithTask < Navigatable
    var exit_code : Int32 = 0

    navigate <<-EOF
      usage: {program} {command} {task} ...

      examples:
      {this_descs}

      {msg}
      EOF
  end

  class MissingCommand < Navigatable
    navigate <<-EOF
      usage: {program} <command> ...
             {program} ^^^^^^^^^

      commands:
          {commands}

      examples:
      {commands_usages}

      missing <command>.
      EOF
  end

  class InvalidCommand < Navigatable
    navigate <<-EOF
      usage: {program} <command> ...
             {program} {command}

      commands:
          {commands}

      examples:
      {commands_usages}

      invalid command: '{command}'
      EOF
  end

  class MissingTask < Navigatable
    navigate <<-EOF
      usage: {program} {command} <task> ...
             {program} {command} ^^^^^^

      tasks:
          {tasks}

      examples:
      {this_descs}

      missing <task>.
      EOF
  end

  class InvalidTask < Navigatable
    navigate <<-EOF
      usage: {program} {command} <task> ...
             {program} {command} {task}

      tasks:
          {tasks}

      examples:
      {this_descs}

      invalid task: '{task}'
      EOF
  end

  class MissingArgument < Navigatable
    navigate <<-EOF
      usage: {program} {command} {task} {args}
             {program} {command} {task} {argv}

      examples:
      {this_task_descs}

      {msg}
      EOF
  end

  class InvalidArgument < Navigatable
    navigate <<-EOF
      usage: {program} {command} {task} {args}
             {program} {command} {task} {argv}

      examples:
      {this_task_descs}

      {msg}
      EOF
  end
end

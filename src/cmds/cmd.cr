abstract class Cmds::Cmd
  var args          : ::Array(String)
  var original_args : ::Array(String)
  var read_arg_idx  : ::Int32       = 0
  var task_state    : ::Cmds::State = ::Cmds::State::BEFORE
  var error         : ::Exception
  var logger        : ::Logger      = ::Logger.new(STDOUT)

  var task_name : ::String
  var prog_name : ::String = PROGRAM_NAME

  ARGS_HINTS = Hash(String, String?).new

  NAME = "(name not found)"

  def self.cmd_name
    NAME
  end

  def task_name
    @task_name || raise TaskNotFound.new("", self)
  end

  module DefaultActions
    def before
    end

    def after
    end

    def run
      invoke_task(task_name)
    end

    def run(args : Array(String))
      self.args = args
      self.task_state = Cmds::State::BEFORE
      self.task_name = args.shift?
      self.original_args = args.dup
      before
      self.task_state = Cmds::State::RUNNING
      run
      self.task_state = Cmds::State::FINISHED
    rescue Cmds::Finished
      # successfully done
    rescue err : Cmds::ArgumentError
      STDERR.puts err.to_s
      exit 1
    rescue err
      self.error = err
      raise err
    ensure
      after
    end

    def finished!(msg : String = "")
      self.task_state = Cmds::State::FINISHED
      raise Cmds::Finished.new(msg)
    end

    def abort(msg)
      raise Abort.new(msg)
    end
  end

  # should be overriden in inherited macro
  def self.pretty_usage(prefix : String = "", delimiter : String = " ")
    ""
  end

  def self.run(args : Array(String))
    c = new
    c.run(args)
    return c
  end

  def self.usages : Array(String)
    @@usages ||= Array(String).new
  end

  def self.usage(v : String)
    usages << v
  end

  macro task(name, args_hint = nil)
    {% key = name.id.stringify.gsub(/\./,"__").id %}
    def task__{{key}}
      {{yield}}
    end

    ::Cmds::Cmd::ARGS_HINTS["{{key}}"] = {{args_hint}}
  end

  protected def invoke_task(name : String)
    list = Array(String).new
    method_name = "task__" + name.gsub(/\./,"__")
    {% for methods in ([@type] + @type.ancestors).map(&.methods.map(&.name.stringify)) %}
      {% for name in methods.select(&.starts_with?("task__")) %}
        return {{name.id}} if method_name == {{name}}
      {% end %}
    {% end %}
    raise TaskNotFound.new(name, self)
  end

  def self.task_names : Array(String)
    array = Array(String).new
    {% for methods in ([@type] + @type.ancestors).map(&.methods.map(&.name.stringify)) %}
      {% for name in methods.select(&.starts_with?("task__")) %}
        array << {{name}}.sub(/^task__/, "").gsub(/__/,".")
      {% end %}
    {% end %}
    array.sort!
    return array
  end

  {% for name in Logger::Severity.constants %}
    private def {{name.id.downcase}}(message)
      name = String.build do |s|
        s << self.class.cmd_name
        s << " " << task_name if task_name?
      end
      logger.{{name.id.downcase}}(message, name)
    end
  {% end %}

  macro inherited
    def self.cmd_name
      NAME
    end

    def self.pretty_usage(prefix : String = "", delimiter : String = " ")
      array = usages.map{|i| [prefix + PROGRAM_NAME, NAME, i]}
      Pretty.lines(array, delimiter: delimiter)
    end

    def args_got : Array(String)
      [prog_name, NAME, task_name] + original_args
    end

    def args_exp : Array(String)
      exp = [prog_name, NAME, task_name]
      if hint = ::Cmds::Cmd::ARGS_HINTS[task_name]
        exp.concat hint.split(/\s+/)
      end
      return exp
    end

    {% for x in 1..10 %}
      protected def arg{{x}}? : String?
        original_args[{{x}}-1]?
      end

      protected def arg{{x}} : String
        original_args[{{x}}-1]
      rescue ::IndexError
        raise ::Cmds::ArgumentNotFound.new({{x}}-1, args_exp, args_got)
      end

      protected def arg{{x}}?(&block : String -> U) : U? forall U
        arg{{x}}?.try{|v| block.call(v)}
      end

      protected def arg{{x}}(&block : String -> U) : U forall U
        v = arg{{x}}
        begin
          return block.call(v)
        rescue err
          raise ::Cmds::ArgumentNotValid.new({{x}}-1, args_exp, args_got, err)
        end
      end
    {% end %}
  end
end

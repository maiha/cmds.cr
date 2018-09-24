abstract class Cmds::Cmd
  var args   : ::Array(String)
  var task_name : ::String
  var task_state : Cmds::State = Cmds::State::BEFORE
  var error  : Exception

  NAME = "(name not found)"

  def before
  end

  def after
  end

  def finished!(msg = nil)
    self.task_state = Cmds::State::FINISHED
    raise Cli::Finished.new(msg)
  end

  def abort(msg)
    raise Abort.new(msg)
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

  macro task(name)
    def task__{{name.id.stringify.gsub(/\./,"__").id}}
      {{yield}}
    end
  end

  protected def invoke_task(name : String)
    list = Array(String).new
    method_name = "task__" + name.gsub(/\./,"__")
    {% for methods in ([@type] + @type.ancestors).map(&.methods.map(&.name.stringify)) %}
      {% for name in methods.select(&.starts_with?("task__")) %}
        return {{name.id}}() if method_name == {{name}}
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

  def run
    self.task_name = args.shift? || build_task_name
    invoke_task(task_name)
  end

  protected def build_task_name
    raise TaskNotFound.new("", self)
  end

  def run(args : Array(String))
    self.args = args
    self.task_state = Cmds::State::BEFORE
    before
    self.task_state = Cmds::State::RUNNING
    run
    self.task_state = Cmds::State::FINISHED
  rescue err
    self.error = err
    raise err
  ensure
    after
  end

  macro inherited
    def self.pretty_usage(prefix : String = "", delimiter : String = " ")
      array = usages.map{|i| [prefix + PROGRAM_NAME, NAME, i]}
      Pretty.lines(array, delimiter: delimiter)
    end
  end
end

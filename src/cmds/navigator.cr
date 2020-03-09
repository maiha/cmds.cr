module Cmds
  class Navigator
    var colorize : Bool = true
    var program  : String = File.basename(PROGRAM_NAME)

    var default : Hash(String, String) = {
      "program"  => program,
      "commands" => Cmds.names.join(", "),
    }

    def navigate(template : String, vars = Hash(String, String).new) : String
      buf = template
      cmd = Cmds[vars["command"]?.to_s]?

      template.scan(/{([a-z0-9_]+)}/) do
        key    = $1
        target = "{#{key}}"
        value  = nil
        case key
        when "tasks"
          if cmd
            value = cmd.task_names.join(", ")
          end
        when "descs"
          if cmd
            if descs = cmd.descs[vars["task"]?.to_s]?
              value = build_descs(cmd, descs)
            end
          end
          value ||= ""
        when "examples"
          if cmd
            if descs = cmd.descs[vars["task"]?.to_s]?
              value = build_examples(cmd, descs)
            end
          end
          value ||= ""
        else    
          value = vars[key]? || default[key]?
        end
        if value
          buf = buf.gsub(target, value)
        end
      end
      return buf
    end

    def navigate(err : Navigatable) : String
      navigate(err.template, err.vars)
    end

    def build_descs(cmd : Cmd.class, descs : Array(Desc)) : String
      lines = Array(Array(String)).new
      descs.each do |desc|
        lines << [program, cmd.cmd_name, desc.task, desc.text]
      end
      Pretty.lines(lines, indent: "  ", delimiter: " ")
    end

    def build_examples(cmd : Cmd.class, descs : Array(Desc)) : String
      if descs.any?
        String.build do |s|
          s.puts "examples:"
          s.puts build_descs(cmd, descs)
          s.puts
        end
      else
        ""
      end
    end
  end
end

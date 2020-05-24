module Cmds
  class Navigatable < Exception
    var exit_code : Int32 = 1
    var vars = Hash(String, String).new

    TEMPLATES = Hash(String, String).new

    def initialize(**opts)
      set(**opts)
      super(self.class.name)
    end
    
    def self.template(err) : String
      key = err.class.name.sub(/^.*::/, "")
      TEMPLATES[key]? || raise Abort.new("navigator: template not found for '#{key}'")
    end

    def navigate
      Navigator.new.navigate(self)
    end

    def template
      Navigatable.template(self)
    end

    def set(**opts)
      opts.each do |key, val|
        vars[key.to_s] = val.to_s
      end
      return self
    end
    
    macro navigate(tmpl)
      {% key = @type.name.stringify.gsub(/^.*::/, "") %}
      ::Cmds::Navigatable::TEMPLATES[{{key}}] = {{tmpl}}
    end
  end
end
  

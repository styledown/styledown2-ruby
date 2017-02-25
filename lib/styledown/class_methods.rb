class Styledown
  # Functional API for Styledown that interfaces via ExecJS. This is the
  # low-level API that the OOP API uses.
  module ClassMethods
    def context
      @context ||= begin
        require 'execjs'
        ExecJS.compile(Styledown::Source::SOURCE)
      end
    end

    def build(source, options = {})
      context.call('Styledown.build', source, options)
    end

    def render(data, options = {})
      context.call('Styledown.render', data, options)
    end

    # Reimplementation of Styledown.read(). Reads files and returns their
    # contents into a Hash.
    def read(paths, options = {})
      FileReader.read(paths, options)
    end

    def js_version
      context.eval('Styledown.version')
    end
  end
end

class Styledown
  extend self

  def self.context
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

  def read
    # TODO
  end
end

require 'styledown/source'

class Styledown
  def self.context
    @context ||= begin
      require 'execjs'
      ExecJS.compile(Styledown::Source::SOURCE)
    end
  end

  def self.build(source, options = {})
    context.call('Styledown.build', source, options)
  end

  def self.render(data, options = {})
    context.call('Styledown.render', data, options)
  end

  def self.read
    # TODO
  end
end

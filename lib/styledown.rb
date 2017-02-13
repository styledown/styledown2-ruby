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

  # Reimplementation of Styledown.read(). Reads files and returns their contents into a Hash.
  def self.read(paths, options = {})
    paths = [*paths]

    paths.inject({}) do |result, path|
      path = File.absolute_path(path)
      glob = File.join(path, SEARCH_GLOB)
      files = Dir[glob]

      files.each do |file|
        short_file = file[(path.length + File::SEPARATOR.length)..-1]
          .gsub(/#{File::SEPARATOR}/, '/')
        result[short_file] = { 'contents' => File.read(file) }
      end

      result
    end
  end

  SEARCH_GLOB = '{styledown.json,**/*.md,templates/**/*.{html,js,css}}'

  attr_reader :paths
  attr_reader :options
  attr_reader :input
  attr_reader :data
  attr_reader :output

  # Returns a styleguide context.
  def initialize(paths, options = {})
    @paths = paths
    @options = options

    # Pipeline artifacts
    @input = nil
    @data = nil
    @output = nil
  end

  # Re-reads files, processes them, and updates the `#output`.
  #
  # Also aliased as `#reload`.
  def render
    @input  = Styledown.read(@paths, @options)
    @data   = Styledown.build(@input, @options)
    @output = Styledown.render(@data, @options)
    self
  end

  alias :reload :render
end

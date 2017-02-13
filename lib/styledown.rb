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

    @data_filters = []
  end

  # Re-reads files, processes them, and updates the `#output`.
  #
  # Also aliased as `#reload`.
  def render
    @input  = Styledown.read(@paths, @options)
    @data = Styledown.build(@input, @options)
    @data = apply_data_filters(@data)
    @output = Styledown.render(@data, @options)
    self
  end

  def add_data_filter(&blk)
    @data_filters << blk
  end

  # Adds a function that will transform files on `#render`.
  # The given block should return `[filename, file]`.
  def add_file_filter(&blk)
    add_data_filter do |data|
      files = data['files'].map do |filename, file|
        blk.(filename, file) # => [filename, file]
      end
      data['files'] = Hash[files]
      data
    end
  end

  # Adds a function that will transform sections on `#render`.
  def add_section_filter(&blk)
    add_file_filter do |filename, file|
      file['sections'].map! do |section|
        blk.(section, filename, file)
      end if file['sections']
      [filename, file]
    end
  end

  # Adds a function that will transform section parts on `#render`.
  def add_part_filter(&blk)
    add_section_filter do |section, filename, file|
      section['parts'].map! do |part|
        blk.(part, section, filename, file)
      end if section['parts']
      section
    end
  end

  # Adds a function that will transform section part figures on `#render`.
  def add_figure_filter(lang, &blk)
    add_part_filter do |part, section, filename, file|
      if part['isExample'] && [*lang].map(&:to_s).include?(part['language'])
        lang, content = blk.(part['content'])
        part['content'] = content
        part['language'] = lang
        part
      else
        part
      end
    end
  end

  private

  # Applies data filters defined by `add_*_filter` functions.
  def apply_data_filters(data)
    @data_filters.reduce(data) do |data, filter|
      filter.(data)
    end
  end

  alias :reload :render
end

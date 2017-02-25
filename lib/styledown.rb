require 'styledown/class_methods'
require 'styledown/source'
require 'styledown/file_reader'

class Styledown
  extend Styledown::ClassMethods

  # You can change these and they will be honored on next #render
  attr_reader :paths
  attr_reader :options

  # Pipeline artifacts
  attr_reader :mtime     # Last modified time
  attr_reader :input     # Output of Styledown.read
  attr_reader :raw_data  # Output of Styledown.build
  attr_reader :data      # Output of apply_data_filters
  attr_reader :output    # Output of Styledown.render (final output)

  # Returns a styleguide context.
  def initialize(paths = nil, options = {})
    @paths = paths
    @options = options

    @data_filters = []
  end

  def paths=(paths)
    invalidate
    @paths = paths
  end

  def options=(options)
    invalidate
    @options = options
  end

  # Reads files, processes them, and updates the `#output`.
  def render
    invalidate_if_updated
    fast_render
  end

  # Renders without invalidation.
  def fast_render
    @input ||= Styledown.read(@paths, @options)
    @raw_data ||= Styledown.build(@input, @options)
    @data ||= apply_data_filters(@raw_data)
    @output ||= Styledown.render(@data, @options)
    self
  end

  # Like `#render`, but always re-runs.
  # Also aliased as `#reload`.
  def render!
    invalidate
    render
  end

  # Busts the cache
  def invalidate
    @mtime = nil
    @input = nil
    @raw_data = nil
    invalidate_data
  end

  # Busts the cache, partially
  def invalidate_data
    @data = nil
    @output = nil
  end

  def valid?
    !!@output
  end

  def add_data_filter(&blk)
    invalidate_data
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
        res = blk.(part, section, filename, file)
        res
      end if section['parts']
      section
    end
  end

  # Adds a function that will transform section part figures on `#render`.
  def add_figure_filter(lang, &blk)
    add_file_filter do |filename, file|
      if file['layout'] == 'figure' && [*lang].map(&:to_s).include?(file['language'])
        new_lang, new_content = blk.(file['content'])
        file['content'] = new_content
        file['language'] = new_lang
        file
      end
      [filename, file]
    end
  end

  private

  # Checks if it's been update since last call of `#if_updated`.
  def invalidate_if_updated
    mtime = Styledown::FileReader.mtime(@paths)
    if mtime != @mtime
      invalidate
      @mtime = mtime
    end
  end

  # Applies data filters defined by `add_*_filter` functions.
  def apply_data_filters(data)
    @data_filters.reduce(data) do |data_, filter|
      filter.(data_)
    end
  end
end

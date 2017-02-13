class Styledown
  module FileReader
    SEARCH_GLOB = '{styledown.json,**/*.md,templates/**/*.{html,js,css}}'

    def self.read(paths, options = {})
      glob(paths).inject({}) do |result, (file, short_file)|
        result[short_file] = { 'contents' => File.read(file) }
        result
      end
    end

    def self.mtime(paths)
      glob(paths).inject(0) do |mtime, (file, _)|
        new_mtime = File.mtime(file).to_i
        new_mtime > mtime ? new_mtime : mtime
      end
    end

    # Returns a list of files in a `path`. Each item is a tuple of `[full_path,
    # short_path]`.
    #
    #     glob('/path/to/foo')
    #     => [
    #       [ '/path/to/foo/bar.txt', 'bar.txt' ],
    #       [ '/path/to/foo/baz.txt', 'baz.txt' ]
    #     ]
    #
    def self.glob(paths)
      [*paths].inject([]) do |result, path|
        abspath = File.absolute_path(path)
        glob = File.join(abspath, SEARCH_GLOB)

        result + Dir[glob].map do |file|
          short_file = file[(abspath.length + File::SEPARATOR.length)..-1]
            .gsub(/#{File::SEPARATOR}/, '/')

          [file, short_file]
        end
      end
    end
  end
end

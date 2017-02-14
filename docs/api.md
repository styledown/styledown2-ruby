# API

## Styledown

> `styleguide = Styledown.new(path, [options])`

Styledown class.

```rb
styleguide = Styledown.new('/path/to/guides')
styleguide.render

styleguide.output
# => {
#   'buttons.html' => { 'contents' => '...' },
#   'forms.html' => { 'contents' => '...' }
# }
```

### render

> `styleguide.render`

Processes files and updates [#output](#output). Styledown keeps a cache, so this will not re-read or re-process if no files have changed. See [Styledown class](#styledown) for an example.

### fast_render

> `styleguide.fast_render`

Like [#render](#render), but skips checking if any files have been updated. Use this in production.

### render!

> `styleguide.render!`

Forces a [#render](#render) regardless of whether files have changed or not.

### output

> `styleguide.output`

The final transformed files. This is a Hash. See [Styledown class](#styledown) for an example.

### add\_data\_filter

> `styleguide.add_data_filter { |data| ... }`

Adds a function to be invoked on [#render](#render) that will transform Styledown raw data. The given block should return a new `data`, or the same one if it was mutated.

### add\_file\_filter

> `styleguide.add_file_filter { |filename, file| ... }`

Adds a function to be invoked on [#render](#render) that will transform Styledown `file` data. The given block should return a `[filename, file]` tuple.

```rb
styleguide = Styledown.new('/path/to/guides')

styleguide.add_file_filter do |filename, file|
  filename = filename.gsub(/\.html$/, '.htm')
  [filename, file]
end

styleguide.render
```

### add\_section\_filter

> `styleguide.add_section_filter { |section| ... }`

Adds a function to be invoked on [#render](#render) that will transform Styledown `section` data. The given block should return a new `section`, or the same one if it was mutated.

```rb
styleguide = Styledown.new('/path/to/guides')

styleguide.add_section_filter do |section|
  # Prefix id's for whatever reason
  section['id'] = "sg-#{section['id']}"
  section
end

styleguide.render
```

### add\_part\_filter

> `styleguide.add_part_filter { |part| ... }`

Adds a function to be invoked on [#render](#render) that will transform Styledown `part` data. The given block should return a new `part`, or the same one if it was mutated.

```rb
styleguide = Styledown.new('/path/to/guides')

styleguide.add_part_filter do |part|
  part['class'] += ' my-class'
  part
end

styleguide.render
```

### add\_figure\_filter

> `styleguide.add_figure_filter(language) { |content| ... }`

Adds a function to be invoked on [#render](#render) for transpiling example figures. The given block should return `[language, content]` where `language` is the new language it was transformed to, and `content` is the transformed result.

```rb
styleguide = Styledown.new('/path/to/guides')

styleguide.add_figure_filter('erb') do |contetns|
  [ 'html', ERB.render(contents) ]
end

styleguide.render
```

### invalidate

Invalidates the cache so that the next [#render](#render) will always run.

### invalidate_data

Partially invalidates the cache so that the next [#render](#render) will always run the build step. It will not re-run the read step, however.

## Class functions

### Styledown.read

> `Styledown.read(path, [options])`

Reads files in `path` and returns their contents in a Hash, ready to be processed by [styledown.build](#styledown-build). This mirrors the `styledown.read()` implementation in JavaScript.

### Styledown.build

> `Styledown.build(files, [options])`

Processes `files` (as returned by [styledown.read](#styledown-read) and returns data to be rendered. This mirrors the `styledown.build()` implementation in JavaScript.

### Styledown.render

> `Styledown.render(data, [options])`

Processes `data` (as returned by [styledown.build](#styledown-build) and returns output files. This mirrors the `styledown.render()` implementation in JavaScript.

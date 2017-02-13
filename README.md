# Styledown for Ruby

> Write maintainable CSS styleguides using Markdown

Ruby implementation for [Styledown2](https://github.com/styledown/styledown2).

## Install

```
gem 'styledown2'
```

## API

This implements the same API as the JavaScript `styledown2`.

```rb
files  = Styledown.read(...)
data   = Styledown.parse(files)
output = Styledown.render(data)
```

## Thanks

**styledown2-ruby** © 2017+, Rico Sta. Cruz. Released under the [MIT] License.<br>
Authored and maintained by Rico Sta. Cruz with help from contributors ([list][contributors]).

> [ricostacruz.com](http://ricostacruz.com) &nbsp;&middot;&nbsp;
> GitHub [@rstacruz](https://github.com/rstacruz) &nbsp;&middot;&nbsp;
> Twitter [@rstacruz](https://twitter.com/rstacruz)

[MIT]: http://mit-license.org/
[contributors]: http://github.com/styledown/styledown2-ruby/contributors

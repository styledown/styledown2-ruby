require 'minitest/autorun'
require 'styledown'

describe 'Styledown' do
  it 'should work' do
    data = Styledown.build({ 'buttons.md': { contents: '# Hello' } }, skipAssets: true)
    result = Styledown.render(data)

    expect(result['buttons.html']['contents']).must_include "<h1 id='hello'>Hello</h1>"
    expect(result['buttons.html']['contents']).must_include "name='generator' content='Styledown2 2"
  end
end

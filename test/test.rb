require 'minitest/autorun'
require 'styledown'

describe 'Functional API' do
  it 'should work' do
    data = Styledown.build({ 'buttons.md': { contents: '# Hello' } }, skipAssets: true)
    result = Styledown.render(data)

    expect(result['buttons.html']['contents']).must_include "<h1 id='hello'>Hello</h1>"
    expect(result['buttons.html']['contents']).must_include "name='generator' content='Styledown2 2"
  end
end

describe '#read' do
  it 'should work' do
    root = File.expand_path('../fixtures/example', __FILE__)
    files = Styledown.read(root)

    expect(files['buttons.md']['contents']).must_include '# Buttons'
    expect(files['forms.md']['contents']).must_include '# Forms'
    expect(files['templates/head.html']['contents']).must_include 'bootstrap.min.css'
  end
end

describe 'OOP API' do
  it 'should work' do
    root = File.expand_path('../fixtures/example', __FILE__)
    styleguide = Styledown.new(root)
    styleguide.render

    result = styleguide.output

    expect(result['buttons.html']['contents']).must_include 'Buttons</h1>'
    expect(result['forms.html']['contents']).must_include 'Forms</h1>'
    expect(result['buttons.html']['contents']).must_include 'bootstrap.min.css'
  end
end

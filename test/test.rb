require 'minitest/autorun'
require 'styledown'

EXAMPLE = File.expand_path('../fixtures/example', __FILE__)

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
    files = Styledown.read(EXAMPLE)

    expect(files['buttons.md']['contents']).must_include '# Buttons'
    expect(files['forms.md']['contents']).must_include '# Forms'
    expect(files['templates/head.html']['contents']).must_include 'bootstrap.min.css'
  end
end

describe 'OOP API' do
  it 'should work' do
    styleguide = Styledown.new(EXAMPLE)
    styleguide.render

    result = styleguide.output

    expect(result['buttons.html']['contents']).must_include 'Buttons</h1>'
    expect(result['forms.html']['contents']).must_include 'Forms</h1>'
    expect(result['buttons.html']['contents']).must_include 'bootstrap.min.css'
  end

  it 'should honor data filters' do
    styleguide = Styledown.new(EXAMPLE, skipAssets: true)
    styleguide.add_data_filter do |data|
      data['files'].each do |fname, file|
        file['sections'].each do |section|
          section['parts'].each do |part|
            part['preClass'] = 'lang-wololo'
          end if section['parts']
        end if file['sections']
      end
      data
    end
    styleguide.render

    result = styleguide.output

    html = result['buttons.html']['contents']
    expect(html).must_include 'lang-wololo'
  end

  it 'should honor part filters' do
    styleguide = Styledown.new(EXAMPLE, skipAssets: true)
    styleguide.add_part_filter do |part|
      part['preClass'] = 'lang-wololo'
      part
    end
    styleguide.render

    result = styleguide.output

    html = result['buttons.html']['contents']
    expect(html).must_include 'lang-wololo'
  end
end

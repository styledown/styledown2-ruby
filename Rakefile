task default: :test

desc 'Runs tests'
task :test do
  $:.unshift(File.expand_path(__FILE__, '../lib'))
  Dir['test/**/*test.rb'].each { |fn| require_relative fn }
end

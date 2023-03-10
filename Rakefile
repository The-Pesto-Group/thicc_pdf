require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rails/version'
require 'bundler/gem_tasks'

desc 'Default: run unit tests.'
task default: %i[setup_and_run_tests rubocop]

desc 'Test the thicc_pdf plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Run RuboCop'
task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

desc 'Setup and run all tests'
task :setup_and_run_tests do
  Rake::Task[:dummy_generate].invoke unless File.exist?('test/dummy/config/environment.rb')
  Rake::Task[:test].invoke
end

desc 'Generate dummy application for test cases'
task :dummy_generate do
  Rake::Task[:dummy_remove].invoke
  puts 'Creating dummy application to run tests'
  system('rails new test/dummy --database=sqlite3')
  system('touch test/dummy/db/schema.rb')
  FileUtils.cp 'test/fixtures/database.yml', 'test/dummy/config/'
  FileUtils.rm_r Dir.glob('test/dummy/test/*')

  # rails 6 needs this to be present before start:
  FileUtils.mkdir_p('test/dummy/app/assets/config')
  FileUtils.mkdir_p('test/dummy/app/assets/javascripts')
  FileUtils.cp 'test/fixtures/manifest.js', 'test/dummy/app/assets/config/'
  FileUtils.cp 'test/fixtures/thicc.js', 'test/dummy/app/assets/javascripts/'
end

desc 'Remove dummy application'
task :dummy_remove do
  FileUtils.rm_r Dir.glob('test/dummy/')
end

desc 'Generate documentation for the thicc_pdf gem.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ThiccPdf'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

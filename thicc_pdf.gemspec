lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thicc_pdf/version'
require 'English'

Gem::Specification.new do |spec|
  spec.name          = 'thicc_pdf'
  spec.version       = ThiccPdf::VERSION
  spec.authors       = ['Miles Z. Sterrett', 'David Jones']
  spec.email         = ['miles.sterrett@gmail.com', 'unixmonkey1@gmail.com']
  spec.summary       = 'PDF generator (from HTML) for Ruby on Rails'
  spec.homepage      = 'https://github.com/The-Pesto-Group/thicc_pdf'
  spec.license       = 'MIT'
  spec.date          = Time.now.strftime('%Y-%m-%d')
  spec.description   = 'A fork of Wicked PDF. Uses WeasyPrint instead of wkhtmltopdf.'
  spec.metadata =    {
    'changelog_uri' => 'https://github.com/The-Pesto-Group/thicc_pdf/blob/master/CHANGELOG.md'
  }

  spec.required_ruby_version = Gem::Requirement.new('>= 2.2')
  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.requirements << 'weasyprint'

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'mocha', '= 1.3'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '~> 1.24'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'test-unit'
end

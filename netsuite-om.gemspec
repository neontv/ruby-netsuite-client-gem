# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{netsuite-om}
  s.version = "1.0"

  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stan Mazhara"]
  s.date = %q{2014-01-15}
  s.description = %q{Ruby soap4r-based Netsuite client.}
  s.email = ['stan@ouya.tv']
  s.rdoc_options += %w(-m README.rdoc -x lib/netsuite/soap*.* lib/netsuite/netsuite* lib/netsuite/string.rb lib/netsuite/symbol.rb lib/netsuite/client.rb README.rdoc)
  s.extra_rdoc_files = %w(CHANGELOG Manifest.txt)
  s.files = %w(CHANGELOG Manifest.txt README.rdoc Rakefile TODO netsuite-om.gemspec) + Dir['lib/**/*.rb'] + Dir['spec/*.rb']
  #s.homepage = %q{http://rubygems.org/gems/netsuite_client}
#  s.post_install_message = %q{PostInstall.txt}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby soap4r-based Netsuite client.}
#  s.test_files = ["test/netsuite_test.rb", "test/test_helper.rb"]

  s.add_dependency 'soap4r-ruby1.9'
  s.add_dependency 'activesupport'#, '~> 3..0'

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
end

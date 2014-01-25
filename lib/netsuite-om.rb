$:.unshift(File.dirname(__FILE__) + '/netsuite')

require 'rubygems'
gem 'soap4r-ruby1.9'

require 'active_support/inflector'
require 'forwardable'

module NetSuite
  $:.unshift(File.dirname(__FILE__) + '/netsuite/soap')
  require 'soap/default'
  require 'soap/defaultDriver'
  require 'soap/defaultMappingRegistry'
  require 'NetSuiteServiceClient'
  $:.shift

  Dir.chdir(File.dirname(__FILE__) + '/netsuite') do
    Dir[*%w(
      helpers/*.rb
      accounting/*.rb
      core/*.rb
      messages/*.rb
      relationships/*.rb
      sales/*.rb
    )].each do |file|
      require file
    end
  end

  class Client
    VERSION = '1.0'
  end
end


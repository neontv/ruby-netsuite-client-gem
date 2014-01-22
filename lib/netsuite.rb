$:.unshift(File.dirname(__FILE__))
$:.unshift(File.dirname(__FILE__) + '/netsuite')

require 'rubygems'
gem 'soap4r-ruby1.9'

require 'netsuite/default'
require 'netsuite/defaultDriver'
require 'netsuite/defaultMappingRegistry'
require 'netsuite/NetSuiteServiceClient'
require 'netsuite/client'

module NetSuite
  class Client
    VERSION = '1.0'
  end

  autoload :SearchResponseMethods, 'netsuite/objects/search_response_methods'
end

Dir[File.dirname(__FILE__) + '/netsuite/objects/*.rb'].each do |file|
  require file
end


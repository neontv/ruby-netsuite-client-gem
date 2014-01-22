$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'netsuite_client/string'
require 'netsuite_client/symbol'

require 'netsuite_client/soap/add_response'
require 'netsuite_client/soap/get_response'
require 'netsuite_client/soap/delete_response'
require 'netsuite_client/soap/search_response_methods'
require 'netsuite_client/soap/search_response'
require 'netsuite_client/soap/search_more_with_id_response'
require 'netsuite_client/soap/record'
require 'netsuite_client/soap/partner'
require 'netsuite_client/soap/vendor'
require 'netsuite_client/soap/non_inventory_sale_item'

require 'rubygems'
gem 'soap4r-ruby1.9'

DEFAULT_NS_WSDL_VERSION = '2012_2'
if ENV['FORCE_NS_WSDL_VERSION']
  begin
    require "netsuite_client/soap_netsuite_#{ENV['FORCE_NS_WSDL_VERSION']}"
  rescue LoadError
    puts "Error loading WSDL #{ENV['FORCE_NS_WSDL_VERSION']}, trying to load default WSDL: #{DEFAULT_NS_WSDL_VERSION}"
    require "netsuite_client/soap_netsuite_#{DEFAULT_NS_WSDL_VERSION}"
  end
else
  require "netsuite_client/soap_netsuite_#{DEFAULT_NS_WSDL_VERSION}"
end

require 'netsuite_client/netsuite_exception'
require 'netsuite_client/netsuite_result'
require 'netsuite_client/netsuite_result_list'
require 'netsuite_client/client'
require 'active_support/inflections'

class NetSuite::Client
  VERSION = '1.0'
end

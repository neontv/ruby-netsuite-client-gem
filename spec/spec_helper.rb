require 'simplecov'
SimpleCov.start

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))
require 'netsuite-om'
require 'webmock'

include NetSuite
RSpec.configure do |config|
  WebMock.disable_net_connect!
end


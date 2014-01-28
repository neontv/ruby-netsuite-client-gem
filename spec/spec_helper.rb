$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift File.expand_path(File.join(File.dirname(__FILE__)))
require 'netsuite-om'

  include NetSuite
  NetSuite::NonInventorySaleItem
RSpec.configure do |config|
  config.include NetSuite
end

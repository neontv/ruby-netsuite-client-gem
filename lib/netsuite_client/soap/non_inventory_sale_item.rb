module NetSuite
module SOAP

class NonInventorySaleItem < NetSuite::SOAP::Record
  def self.basic_search_class
    ::NetSuite::SOAP::ItemSearchBasic
  end
end

end
end


module NetSuite

class NonInventorySaleItem < NetSuite::Record
  def self.basic_search_class
    NetSuite::ItemSearchBasic
  end
end

end


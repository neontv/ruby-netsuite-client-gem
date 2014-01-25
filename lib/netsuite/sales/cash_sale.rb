module NetSuite

class CashSale < NetSuite::Record
  class << self
    def basic_search_class
      NetSuite::TransactionSearchBasic
    end
  end
end

end


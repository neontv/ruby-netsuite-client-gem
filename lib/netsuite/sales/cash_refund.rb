module NetSuite

class CashRefund < NetSuite::Record
  class << self
    def basic_search_class
      NetSuite::TransactionSearchBasic
    end
  end
end

end


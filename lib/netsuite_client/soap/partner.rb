module NetSuite
module SOAP

class Partner < NetSuite::SOAP::Record
  def vendor
    @vendor ||= begin
                  vendor = NetSuite::SOAP::Vendor.new
                  vendor.internal_id = internal_id
                  vendor
                end
  end

  def eligible_for_commission?
    eligible_for_commission
  end
end

end
end

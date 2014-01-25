module NetSuite

class Partner < NetSuite::Record
  def vendor
    @vendor ||= begin
                  vendor = NetSuite::Vendor.new
                  vendor.internal_id = internal_id
                  vendor
                end
  end

  def eligible_for_commission?
    eligible_for_commission
  end
end

end


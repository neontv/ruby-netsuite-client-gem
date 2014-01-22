module NetSuite

class Vendor < NetSuite::Record
  def partner
    @partner ||= begin
                  partner = NetSuite::Partner.new
                  partner.internal_id = internal_id
                  partner
                end
  end
end

end


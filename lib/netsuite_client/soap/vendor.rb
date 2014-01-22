module NetSuite
module SOAP

class Vendor < NetSuite::SOAP::Record
  def partner
    @partner ||= begin
                  partner = NetSuite::SOAP::Partner.new
                  partner.internal_id = internal_id
                  partner
                end
  end
end

end
end

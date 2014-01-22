module NetSuite

class Result < Struct.new(:response)
  def success?
    response.status.xmlattr_isSuccess
  end

  def internal_id
    response.baseRef.xmlattr_internalId.to_i rescue nil
  end

  def external_id
    response.baseRef.xmlattr_externalId rescue nil
  end

  def error_message
    response.status.statusDetail[0].message if !success?
  end

  def error_code
    response.status.statusDetail[0].code if !success?
  end
end

end

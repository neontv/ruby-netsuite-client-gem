module NetSuite
module SOAP

class AddResponse
  def success?
    status.xmlattr_isSuccess
  end

  def internal_id
    base_ref.xmlattr_internalId
  end

  def external_id
    base_ref.xmlattr_externalId
  end

  def type
    base_ref.xmlattr_type
  end

  private

  def status
    writeResponse.status
  end

  def base_ref
    writeResponse.baseRef
  end
end

end
end

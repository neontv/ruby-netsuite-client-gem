module NetSuite

class GetResponse
  NOT_FOUND = "RCRD_DSNT_EXIST"

  def record
    readResponse.record
  end

  def success?
    readResponse.status.xmlattr_isSuccess
  end

  def internal_id
    readResponse.record.xmlattr_internalId.to_i rescue nil
  end

  def external_id
    readResponse.record.xmlattr_externalId rescue nil
  end

  def error_message
    readResponse.status.statusDetail[0].message if !success?
  end

  def error_code
    readResponse.status.statusDetail[0].code if !success?
  end

  def not_found?
    error_code == NOT_FOUND
  end
end

end


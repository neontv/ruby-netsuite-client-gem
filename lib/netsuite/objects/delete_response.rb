module NetSuite

class DeleteResponse
  NOT_FOUND = "RCRD_DSNT_EXIST"

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

  def code
    status_detail.code
  end

  def message
    status_detail.message
  end

  def not_found?
    code == NOT_FOUND
  end

  private

  def status
    writeResponse.status
  end

  def base_ref
    writeResponse.baseRef
  end

  def status_detail
    status.statusDetail[0]
  end
end

end


module NetSuite

class WriteResponse
  DUP_ITEM = 'DUP_ITEM'
  DUP_RCRD = 'DUP_RCRD'
  DUP_ENTITY = 'DUP_ENTITY'
  DUP_VENDOR_NAME = 'DUP_VENDOR_NAME'
  RCRD_TYPE_REQD = 'RCRD_TYPE_REQD'
  USER_ERROR = 'USER_ERROR'

  def success?
    status.xmlattr_isSuccess
  end

  def internal_id
    base_ref.xmlattr_internalId rescue nil
  end

  def external_id
    base_ref.xmlattr_externalId rescue nil
  end

  def type
    base_ref.xmlattr_type rescue nil
  end

  def code
    status_detail.code
  end

  def message
    status_detail.message
  end

  def dup_item?
    code == DUP_ITEM
  end

  def dup_rcrd?
    code == DUP_RCRD
  end

  def dup_entity?
    code == DUP_ENTITY
  end

  def dup_vendor_name?
    code == DUP_VENDOR_NAME
  end

  def rcrd_type_reqd?
    code == RCRD_TYPE_REQD
  end

  def user_error?
    code == USER_ERROR
  end

  def duplicate?
    dup_item? || dup_rcrd? || dup_entity? || dup_vendor_name?
  end

  private

  def base_ref
    baseRef
  end

  def status_detail
    status.statusDetail[0]
  end

end

end


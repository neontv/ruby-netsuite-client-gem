module NetSuite

class Status
  DUP_ITEM = 'DUP_ITEM'
  DUP_RCRD = 'DUP_RCRD'
  DUP_ENTITY = 'DUP_ENTITY'
  DUP_VENDOR_NAME = 'DUP_VENDOR_NAME'
  RCRD_TYPE_REQD = 'RCRD_TYPE_REQD'
  USER_ERROR = 'USER_ERROR'
  MAX_RCRDS_EXCEEDED = 'MAX_RCRDS_EXCEEDED'

  def success?
    xmlattr_isSuccess
  end

  def code
    status_detail.code if status_detail
  end

  def message
    status_detail.message if status_detail
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

  def max_rcrds_exceeded?
    code == MAX_RCRDS_EXCEEDED
  end

  def duplicate?
    dup_item? || dup_rcrd? || dup_entity? || dup_vendor_name?
  end

  private

  def status_detail
    statusDetail[0] if statusDetail
  end
end

end

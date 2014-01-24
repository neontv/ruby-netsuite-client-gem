module NetSuite

class WriteResponse
  extend Forwardable

  def_delegators :status, :success?, :code, :message, :dup_item?, :dup_rcrd?,
    :dup_entity?, :dup_vendor_name?, :rcrd_type_reqd?, :user_error?,
    :duplicate?

  def_delegators :baseRef, :internal_id, :external_id, :type
end

end


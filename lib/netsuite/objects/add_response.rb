module NetSuite

class AddResponse
  extend Forwardable

  def_delegators :writeResponse,
    :success?, :internal_id, :external_id, :type, :code, :message, :duplicate?,
    :dup_item?, :dup_rcrd?, :dup_entity?, :dup_vendor_name?

end

end


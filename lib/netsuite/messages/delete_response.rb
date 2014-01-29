module NetSuite

class DeleteResponse
  extend Forwardable

  alias_method :response, :writeResponse

  def_delegators :response, :status, :ref
end

end


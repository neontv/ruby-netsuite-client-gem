module NetSuite

class RecordRef < BaseRef
  alias_method :internal_id, :xmlattr_internalId
  alias_method :internal_id=, :xmlattr_internalId=
  alias_method :external_id, :xmlattr_externalId
  alias_method :external_id=, :xmlattr_externalId=
  alias_method :type, :xmlattr_type
  alias_method :type=, :xmlattr_type=
end

end

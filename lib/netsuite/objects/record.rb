module NetSuite

class Record
  def method_missing(method, *args, &block)
    if %i(internal_id external_id internal_id= external_id=).include?(method)
      method = ('xmlattr_' + method.to_s.camelize(:lower)).to_sym
    else
      method = method[8..-1] if method.to_s.starts_with?('xmlattr_')
      method = 'is_' + method.to_s[0..-2] if method.to_s.ends_with?('?')
      method = method.to_s.camelize(:lower).to_sym
    end
    if self.class.instance_methods(false).include?(method)
      send method, *args, &block
    else
      super
    end
  end

  class << self
    def client
      @@client
    end

    def client=(client)
      @@client = client
    end

    def type
      type = to_s.split('::').last
      type[0,1].downcase + type[1..-1]
    end

    def find_by_internal_id(id)
      find_by_id(internal: id)
    end

    def find_by_external_id(id)
      find_by_id(external: id)
    end

    def find_by_id(ids)
      ref = ::RecordRef.new
      ref.xmlattr_type = type
      ref.xmlattr_externalId = ids[:external]
      ref.xmlattr_internalId = ids[:internal]
      client.get(ref).record
    end

    def basic_search_class
      "::#{to_s}SearchBasic".constantize
    end

    def search(search = basic_search_class.new)
      case search
      when SearchRecord
        client.search(search)
      when SearchResponse
        client.search_next(search, search.page_index + 1)
      when SearchMoreWithIdResponse
        client.search_next(search, search.page_index + 1)
      end
    end

    def search_next(search_result, page_index)
      client.search_next(search, page_index)
    end

    def delete_list(records)
      client.delete_list(records.map { |record| record.ref })
    end
  end

  def add
    res = client.add(self)
    if res.success?
      self.internal_id = res.internal_id
    end
    res
  end

  def update
    client.update(self)
  end

  def delete
    client.delete(ref)
  end

  def load
    self.class.find_by_internal_id(internal_id)
  end

  def client
    self.class.client
  end

  def type
    self.class.type
  end

  def ref
    @ref ||= begin
               ref = RecordRef.new
               ref.xmlattr_type = type
               ref.xmlattr_internalId = internal_id
               ref
             end
  end
end

end


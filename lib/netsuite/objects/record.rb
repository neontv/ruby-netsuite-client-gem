module NetSuite

class Record
  include MethodInflector

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
      ref = RecordRef.new
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

    def delete(*records)
      client.delete_list(records.flatten.map { |record| record.ref })
    end

    def deleted(op, val)
      op = ('NetSuite::SearchDateFieldOperator::' + op.to_s.camelize).constantize
      val = ('NetSuite::SearchDate::' + val.to_s.camelize).constantize
      search_value = SearchDateField.new
      search_value.xmlattr_operator = op
      search_value.predefinedSearchValue = val

      search_type = SearchEnumMultiSelectField.new
      search_type.xmlattr_operator = SearchEnumMultiSelectFieldOperator::AnyOf
      search_type.searchValue = type

      get_deleted_filter = GetDeletedFilter.new(search_value, search_type)
      client.get_deleted(get_deleted_filter)
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

  def client
    self.class.client
  end

  def type
    self.class.type
  end

  def load
    return self if loaded?

    record = by_internal_id || by_external_id or raise NotFoundError

    record.getters.each do |getter|
      send :"#{getter}=", record.send(getter)
    end
    @loaded = true
    self
  end

  def loaded?
    !!@loaded
  end

  def ref
    @ref ||= begin
               ref = RecordRef.new
               ref.xmlattr_type = type
               ref.xmlattr_internalId = internal_id
               ref
             end
  end

  def setters
    public_methods(false).grep(/=$/)
  end

  def getters
    setters.map(&:to_s).map(&:chop).map(&:to_sym)
  end

  private

  def by_internal_id
    self.class.find_by_internal_id(internal_id) if internal_id
  end

  def by_external_id
    self.class.find_by_external_id(external_id) if external_id
  end
end

end


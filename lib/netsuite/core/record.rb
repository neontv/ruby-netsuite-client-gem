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

    def find_by_id(args)
      client.get(ref(args)).record
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
      else
        raise "Unrecognized search:#{search}"
      end
    end

    def search_next(search_result, page_index)
      client.search_next(search, page_index)
    end

    def search_by(*args)
      if args.first.is_a?(Hash)
        key, value = args.first.flatten
        op = :is
      end
      if args.size == 3
        key, op, value = args
      end

      search = basic_search_class.new
      search.send("#{key}=", search_class(value).new)
      search.send(key).xmlattr_operator = search_operator(op, value)
      search.send(key).searchValue = value
      puts search

      search(search)
    end

    def search_class(value)
      case value
      when String
        SearchStringField
      when Fixnum
        SearchLongField
      end
    end

    def search_operator(op, value)
      operator_constant_name = op.to_s.camelize
      operator_class_name = search_class(value).to_s + "Operator"
      "#{operator_class_name}::#{operator_constant_name}".constantize
    end

    def delete(objects)
      client.delete_list(refs(objects))
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

    def ref(arg)
      ref = RecordRef.new
      ref.type = type
      arg = {internal_id: arg} unless arg.is_a?(Hash)
      ref.internal_id = arg[:internal_id]
      ref.external_id = arg[:external_id]
      ref
    end

    private

    def refs(objects)
      objects.map do |object|
        case object
        when RecordRef
          object
        when Record
          object.ref
        when String, Integer
          ref(object)
        end
      end
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

  def load
    return self if loaded?

    record = find_by_id
    record.getters.each do |getter|
      send :"#{getter}=", record.send(getter)
    end
    @loaded = true
    self
  end

  def loaded?
    !!@loaded
  end

  def active?
    !inactive?
  end

  def ref
    self.class.ref(internal_id)
  end

  def setters
    public_methods(false).grep(/=$/)
  end

  def getters
    setters.map(&:to_s).map(&:chop).map(&:to_sym)
  end

  private

  def find_by_id
    by_internal_id || by_external_id or raise_not_found_error
  end

  def by_internal_id
    self.class.find_by_internal_id(internal_id) if internal_id
  end

  def by_external_id
    self.class.find_by_external_id(external_id) if external_id
  end

  def raise_not_found_error
    raise NotFoundError, not_found_error_message
  end

  def not_found_error_message
    "type: #{type}, internal_id: #{internal_id}, external_id: #{external_id}"
  end

  def type
    self.class.type
  end
end

end


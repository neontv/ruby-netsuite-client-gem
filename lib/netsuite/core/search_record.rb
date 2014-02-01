module NetSuite

class SearchRecord
  include Enumerable
  extend Forwardable

  def each
    response.each do |result|
      yield result if block_given?
    end
  end

  def where(*args)
    dup.send(:add, *args)
  end

  def to_a
    response.to_a
  end

  def inactive
    dup.send(:add, isInactive: true)
  end

  def active
    dup.send(:add, isInactive: false)
  end

  def response
    @response ||= client.search(self)
  end

  private

  attr_reader :key, :value, :op

  def client
    Record.client
  end

  def add(*args)
    if args.first.is_a?(Hash)
      @key, @value = args.first.flatten
      @op = :is
    end
    if args.size == 3
      @key, @op, @value = args
    end

    send("#{key}=", search_class.new)
    unless value == true || value == false
      send(key).xmlattr_operator = search_operator
    end
    send(key).searchValue = value

    self
  end

  def search_class
    puts value.inspect
    case value
    when String
      SearchStringField
    when Fixnum
      SearchLongField
    when TrueClass, FalseClass
      SearchBooleanField
    when Date, DateTime
      SearchDateField
    end
  end

  def search_operator
    operator_constant_name = op.to_s.camelize
    operator_class_name = search_class.to_s + "Operator"
    "#{operator_class_name}::#{operator_constant_name}".constantize
  end

  def record_class
    "::#{self.class.to_s.gsub(/SearchBasic$/, '')}".constantize
  end
end

end


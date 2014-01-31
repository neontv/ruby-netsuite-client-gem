module NetSuite

module MethodInflector
  def method_missing(method, *args, &block)
    @method = method

    case
    when xmlattr_method?
      convert_xmlattr_method
    when special_method?
      convert_special_method
    else
      convert_regular_method
    end

    if method_valid?
      send remove_instance_variable(:@method), *args, &block
    else
      remove_instance_variable(:@method)
      super
    end
  end

  private

  attr_reader :method, :args, :block

  def method_valid?
    self.class.instance_methods(false).include?(method)
  end

  def convert_regular_method
    @method = 'is_' + method.to_s[0..-2] if method.to_s.end_with?('?')
    @method = method.to_s.camelize(:lower).to_sym
  end

  def convert_xmlattr_method
    @method = ('xmlattr_' + method.to_s.camelize(:lower)).to_sym
  end

  def convert_special_method
    @method = special_methods_map[method]
  end

  def special_methods_map
    {
      custom_fields: :customFieldList
    }
  end

  def special_method?
    special_methods_map.keys.include?(method)
  end

  def xmlattr_method?
    xmlattr_methods.include?(method)
  end

  def xmlattr_methods
    xmlattr_getters + xmlattr_setters
  end

  def xmlattr_getters
    %i(internal_id external_id script_id)
  end

  def xmlattr_setters
    xmlattr_getters.map { |getter| (getter.to_s + '=').to_sym }
  end
end

end

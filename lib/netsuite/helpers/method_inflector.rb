module NetSuite

module MethodInflector
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
end

end

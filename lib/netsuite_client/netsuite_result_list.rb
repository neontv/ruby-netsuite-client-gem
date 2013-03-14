class NetsuiteResultList < ::Array
  def initialize(list)
    list.each { |res| self << NetsuiteResult.new(res) }
  end
end

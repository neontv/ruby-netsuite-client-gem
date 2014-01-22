module NetSuite

class ResultList < ::Array
  def initialize(list)
    list.each { |res| self << Result.new(res) }
  end
end

end

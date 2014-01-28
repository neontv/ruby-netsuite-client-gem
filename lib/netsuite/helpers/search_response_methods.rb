module NetSuite

module SearchResponseMethods
  include Enumerable

  def each
    records.each do |record|
      yield record if block_given?
    end
  end

  def success?
    status.xmlattr_isSuccess
  end

  def page_index
    searchResult.pageIndex
  end

  def page_size
    searchResult.pageSize
  end

  def id
    searchResult.searchId
  end

  def total_pages
    searchResult.totalPages
  end

  def total_records
    searchResult.totalRecords
  end

  def has_more?
    page_index < total_pages
  end

  private

  def status
    searchResult.status
  end

  def records
    searchResult.recordList
  end
end

end


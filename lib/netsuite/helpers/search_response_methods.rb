module NetSuite

module SearchResponseMethods
  def success?
    status.xmlattr_isSuccess
  end

  def page_index
    searchResult.pageIndex
  end

  def page_size
    searchResult.pageSize
  end

  def records
    searchResult.recordList
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
end

end


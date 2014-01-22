require 'logger'
require 'net/http'
require 'net/https'
require 'soap/header/simplehandler'

module NetSuite

class Client
  attr_reader :driver

  class NetsuiteHeader < SOAP::Header::SimpleHandler
    def initialize(prefs = {})
      @prefs = self.class::DefaultPrefs.merge(prefs)
      super(XSD::QName.new(nil, self.class::Name))
    end

    def on_simple_outbound
      @prefs
    end
  end

  class SearchPreferencesHeaderHandler < NetsuiteHeader
    Name = 'searchPreferences'
    DefaultPrefs = {:bodyFieldsOnly => false, :pageSize => 25}
  end

  class PreferencesHeaderHandler < NetsuiteHeader
    Name = 'preferences'
    DefaultPrefs = {:warningAsError => false, :ignoreReadOnlyFields => true}
  end

  class PassportHeaderHandler < NetsuiteHeader
    Name = 'passport'
    DefaultPrefs = {:account => '', :email => '', :password => ''}
  end

  attr_reader :logger

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def initialize(config = {})
    @driver = NetSuitePortType.new(config[:endpoint_url] || NetSuitePortType::DefaultEndpointUrl)

    if config[:role]
      role = {:xmlattr_internalId => config[:role]}
    end

    @driver.headerhandler.add(PassportHeaderHandler.new(
      email: config[:email],
      password: config[:password],
      account: config[:account_id],
      role: role
    ))
    @driver.headerhandler.add(PreferencesHeaderHandler.new)
    @driver.headerhandler.add(SearchPreferencesHeaderHandler.new)
  end

  def debug=(debug)
    @driver.wiredump_dev = $stderr if debug
  end

  def find_by_internal_ids(klass, ids)
    basic = klass.new

    basic.internalId = SearchMultiSelectField.new
    basic.internalId.xmlattr_operator = SearchMultiSelectFieldOperator::AnyOf
    basic.internalId.searchValue = ids.map do |id|
      record = RecordRef.new
      record.xmlattr_internalId = id
      record
    end

    full_basic_search(basic)
  end

  # Low level commands
  def get(ref)
    @driver.get(GetRequest.new(ref))
  end

  def get_all(refs)
    @driver.getList(GetListRequest.new(refs))
  end

  def get_all_records(record_type)
    ref = GetAllRecord.new
    ref.xmlattr_recordType = record_type
    get_all(ref)
  end

  def get_all(ref)
    @driver.getAll(GetAllRequest.new(ref))
  end

  def add(record)
    @driver.add(AddRequest.new(record))
  end

  # Only supports equality for integers and strings for now.
  def find_by(klass, name, value)
    basic = klass.new

    if value.is_a?(Fixnum)
      @ref = basic.send("#{name}=".to_sym, SearchLongField.new)
      @ref.xmlattr_operator = SearchLongFieldOperator::EqualTo
    else
      @ref = basic.send("#{name}=".to_sym, SearchStringField.new)
      @ref.xmlattr_operator = SearchStringFieldOperator::Is
    end

    @ref.searchValue = value

    full_basic_search(basic)
  end

  def add_list(list)
    @driver.addList(AddListRequest.new(list)).writeResponseList
  end

  def update(ref)
    @driver.update(UpdateRequest.new(ref)).writeResponse
  end

  def update_list(refs)
    @driver.updateList(UpdateListRequest.new(refs)).writeResponseList
  end

  def upsert(record)
    @driver.upsert(UpsertRequest.new(record)).writeResponse
  end

  def upsert_list(refs)
    @driver.upsertList(UpsertListRequest.new(refs)).writeResponseList
  end

  def typify(record)
    record.class.to_s.split('::').last.sub(/^(\w)/) {|s|$1.downcase}
  end

  def delete(ref)
    @driver.delete(DeleteRequest.new(ref))
  end

  def delete_list(refs)
    @driver.deleteList(DeleteListRequest.new(refs))
  end

  def search(search_record)
    @driver.search(SearchRequest.new(search_record))
  end

  def search_next(search_response, page_index = search.page_index + 1)
    @driver.searchMoreWithId(
      searchId: search_response.id,
      pageIndex: page_index
    )
  end

  def search_all(search_record)
    search(search_record) +
      (@res.searchResult.totalPages-1).times.map { |page_index| search_next }
  end
end

end

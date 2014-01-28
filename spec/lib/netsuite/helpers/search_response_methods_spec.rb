require 'spec_helper'

describe SearchResponseMethods do
  class Response
    include SearchResponseMethods
    attr_accessor :records
  end
  let(:response) { Response.new }
  before do
    response.stub(
      status: status,
      searchResult: result
    )
  end
  let(:status) { double }
  let(:result) { double }

  describe '#each' do
    subject { response.each }
    before { response.records = [1,2,3] }
    its(:to_a) { should eq [1,2,3] }
  end

  describe '#success?' do
    subject { response.success? }
    let(:status) { double xmlattr_isSuccess: true }
    it { should be_true }
  end

  describe '#page_index' do
    subject { response.page_index }
    let(:result) { double pageIndex: 123 }
    it { should eq 123 }
  end

  describe '#page_size' do
    subject { response.page_size }
    let(:result) { double pageSize: 234 }
    it { should eq 234 }
  end

  describe '#id' do
    subject { response.id }
    let(:result) { double searchId: 45 }
    it { should eq 45 }
  end

  describe '#total_pages' do
    subject { response.total_pages }
    let(:result) { double totalPages: 56 }
    it { should eq 56 }
  end

  describe '#total_records' do
    subject { response.total_records }
    let(:result) { double totalRecords: 67 }
    it { should eq 67 }
  end

  describe '#has_more?' do
    subject { response.has_more? }
    let(:result) do
      double pageIndex: page_index,
             totalPages: total_pages
    end

    context 'when page_index < total_pages' do
      let(:page_index) { 10 }
      let(:total_pages) { 20 }
      it { should be_true }
    end

    context 'when page_index = total_pages' do
      let(:page_index) { 10 }
      let(:total_pages) { 10 }
      it { should be_false }
    end
  end
end

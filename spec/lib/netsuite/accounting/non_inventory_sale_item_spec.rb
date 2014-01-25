require 'spec_helper'

describe NetSuite::NonInventorySaleItem do
  describe '.basic_search_class' do
    subject { described_class.basic_search_class }
    it { should eq NetSuite::ItemSearchBasic }
  end
end


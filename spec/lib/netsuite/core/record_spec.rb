require 'spec_helper'

class NetSuite::Record
  AttrExternalId = XSD::QName.new(nil, "externalId")
  AttrInternalId = XSD::QName.new(nil, "internalId")

  def __xmlattr
    @__xmlattr ||= {}
  end

  def xmlattr_internalId
    __xmlattr[AttrInternalId]
  end

  def xmlattr_internalId=(value)
    __xmlattr[AttrInternalId] = value
  end

  def xmlattr_externalId
    __xmlattr[AttrExternalId]
  end

  def xmlattr_externalId=(value)
    __xmlattr[AttrExternalId] = value
  end

  attr_accessor :foo
  attr_accessor :bar
end

describe Record do
  let(:model) { Record.new args }
  let(:args) { nil }
  let(:client) { double }
  before { described_class.stub(:client) { client } }

  describe '#add' do
    subject { model.add }

    before do
      model.client.stub(:add) { result }
    end
    let(:result) { double success?: success, internal_id: :internal_id }
    let(:success) { true }

    it { should eq result }

    context 'when success' do
      let(:success) { true }
      it { expect { subject }.to change { model.internal_id }.to(:internal_id) }
    end

    context 'when not success' do
      let(:success) { false }
      it { expect { subject }.to_not \
           change { model.internal_id }.to(:internal_id) }
    end
  end

  describe '#update' do
    subject { model.update }

    before { model.client.stub(:update).with(model) { result } }
    let(:result) { double }
    it { should be result }
  end

  describe '#delete' do
    subject { model.delete }

    before { model.client.stub(:delete).with(model.ref) { result } }
    let(:result) { double }
    it { should be result }
  end

  describe '#client' do
    subject { model.client }
    before { model.class.client = client }
    let(:client) { double }

    it { should be client }
  end

  describe '#load' do
    subject { model.load }
    before { model.instance_variable_set(:@loaded, loaded) }
    let(:loaded) { double }

    it { should be model }

    context 'when already loaded' do
      let(:loaded) { true }

      it { should be model }
      it do
        client.should_not_receive(:get)
        subject
      end
    end

    context 'when internal_id is set' do
      let(:loaded) { false }

      before do
        model.internal_id = 123
        client.stub(:get) { double record: record }
      end

      let(:record) do
        double getters: %i(foo bar),
               foo: :foo,
               bar: :bar
      end

      it { expect { subject }.to change { model.loaded? }.to(true) }
      it { expect { subject }.to change { model.foo }.to(:foo) }
      it { expect { subject }.to change { model.bar }.to(:bar) }
    end
  end

  describe '#loaded?' do
    subject { model.loaded? }
    before { model.instance_variable_set(:@loaded, true) }
    it { should be_true }
  end

  describe '#ref' do
    subject { model.ref }
    before { model.stub(:type) { :type } }

    it { should be_a RecordRef }
    its(:type) { should eq :type }
    its(:internal_id) { should eq model.internal_id }
  end

  describe '#setters' do
    subject { model.setters }
    it do
      should =~ %i(foo= bar= nullFieldList=
                   xmlattr_externalId= xmlattr_internalId=)
    end
  end

  describe '#getters' do
    subject { model.getters }
    it do
      should =~ %i(foo bar nullFieldList xmlattr_externalId xmlattr_internalId)
    end
  end
end

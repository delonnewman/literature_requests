require 'spec_helper'

RSpec.describe LR::Request do
  let(:items) { [described_class::Item.new(literature_code: 'wp21.1-E', status: :new)] }
  let(:person) { LR::Person.new(first_name: 'Testy', last_name: 'Tester') }
  let(:request) { described_class.new(items: items, requester: person) }

  it 'should have a collection of items' do
    expect(request.items).to be items
    expect { described_class.new(items: items, status: :new) }.to raise_error(/requester/)
  end

  it 'should have a requester' do
    expect(request.requester).to be person
    expect { described_class.new(requester: person, status: :new) }.to raise_error(/items/)
  end

  context '.[]' do
    it "should accept a graph of attributes and construct a request and it's items" do
      request = described_class[requester: person, items: [{ literature_code: 'wp21.1-E', status: :pending }]]

      expect(request.requester).to be person
      expect(request.items.count).to be 1
      expect(request.items.first.status).to be :pending
    end

    it "should set any items default value to :new, if it's not specified" do
      request = described_class[requester: person, items: [{ literature_code: 'wp21.1-E' }, { literature_code: 'wp21.2-E' }]]

      request.items.each do |item|
        expect(item.status).to be :new
      end
    end
  end

  context '#items' do
    it 'should return a collection of items' do
      request.items.each do |item|
        expect(item).to be_an_instance_of described_class::Item
        expect(item).to respond_to :literature_code
      end
    end

    it 'should have a status' do
      request.items.each do |item|
        expect(item.status).to be :new
      end
    end

    it 'should have predicate methods for each status' do
      request.items.each do |item|
        described_class::Item::STATUSES.keys.each do |status|
          expect(item).to respond_to :"#{status}?"
        end
      end
    end
  
    context '#status' do
      it 'should be one of :new, :pending, :recieved' do
        request.items.each do |item|
          expect(described_class::Item::STATUSES).to include(item.status)
        end
      end

      it 'should map the status to a code' do
        request.items.each do |item|
          expect(item.status_code).to eq described_class::Item::STATUSES[item.status]
        end
      end

      it 'should return the appropriate status if a status_code is given' do
        code   = described_class::Item::STATUS_CODES.keys.sample
        status = described_class::Item::STATUS_CODES[code]
        item   = described_class::Item.new(literature_code: 'wp21.1-E', status_code: code)
        expect(item.status).to be status
      end
    end
  end
end

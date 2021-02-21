require 'spec_helper'

RSpec.describe LR::RequestRecords do
  let(:person) { LR::Congregation.new.first }
  let(:request) { LR::Request[requester: person, items: [{ publication_code: 'wp21.1-E' }, { publication_code: 'wp21.2-E' }]] }
  let(:records) { described_class.new }

  it 'should store requests' do
    expect { records.store_request!(request) }.not_to raise_error
    expect(records.store_request!(request)).to be true
  end

  it 'should have the same request_id for all items' do
    request_id = request.id
    records.store_request!(request)
    request = records.by_id(request_id)
    request_ids = request.items.map(&:request_id).uniq

    expect(request_ids.count).to eq 1
    expect(request_ids.first).not_to be nil
  end

  it 'should retrieve requests by id' do
    records = described_class.new
  end
end

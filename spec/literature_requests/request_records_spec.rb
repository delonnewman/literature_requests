require 'spec_helper'

RSpec.describe LR::RequestRecords do
  let(:person) { LR::Congregation.new.first }
  let(:request) { LR::Request[requester: person, items: [{ publication_code: 'wp21.1-E' }]] }

  it 'should store requests' do
    records = described_class.new
    expect { records.store_request!(request) }.not_to raise_error
    expect(records.store_request!(request)).to be true
  end

  it 'should retrieve requests by id' do
    records = described_class.new
  end
end

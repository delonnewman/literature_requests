require 'spec_helper'

RSpec.describe LR::People do
  let(:person) { LR::Person.new(first_name: 'Testy', last_name: 'Tester') }

  it 'should store requests' do
    records = described_class.new
    expect { records.store!(person) }.not_to raise_error
    expect(records.store!(person)).to be true
  end

  it 'should retrieve requests by id' do
    people = described_class.new
    expect(people.by_id(1)).to be_an_instance_of LR::Person
  end
end

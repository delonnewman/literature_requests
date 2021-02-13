require 'spec_helper'

RSpec.describe LiteratureRequests::Person do
  it 'should have a first_name and last_name' do
    person = described_class.new(first_name: 'Testy', last_name: 'Tester')
    expect(person.first_name).to eq 'Testy'
    expect(person.last_name).to eq 'Tester'

    expect { described_class.new(first_name: 'Testy') }.to raise_error(/last_name/)
    expect { described_class.new(last_name: 'Tester') }.to raise_error(/first_name/)
  end
end

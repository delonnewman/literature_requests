require 'spec_helper'

RSpec.describe LR::Group do
  it 'should have an overseer and an assistant' do
    overseer = LR::Person.new(first_name: 'Testy', last_name: 'Tester')
    assistant = LR::Person.new(first_name: 'Testa', last_name: 'Testing')

    group = described_class.new(overseer: overseer, assistant: assistant)
    expect(group.overseer).to be overseer
    expect(group.assistant).to be assistant

    expect { described_class.new(overseer: overseer) }.to raise_error(/assistant/)
    expect { described_class.new(assistant: assistant) }.to raise_error(/overseer/)
  end
end

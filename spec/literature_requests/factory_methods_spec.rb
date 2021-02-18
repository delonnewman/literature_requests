require 'spec_helper'

RSpec.describe LiteratureRequests do
  describe '.magazines' do
    it 'should return an array of publications according to the generation rules' do
      mags = described_class.magazines(code: :wp, year: 2021)

      expect(mags.count).to be 3
      expect(mags.first).to be_an_instance_of LiteratureRequests::Publication
      expect(mags.first.code).to eq 'wp21.1-E'
      expect(mags.first.name).to eq 'Watchtower (public edition) No. 1 2021'

      mags = described_class.magazines(code: :w, year: 2021)

      expect(mags.count).to be 12
      expect(mags.first).to be_an_instance_of LiteratureRequests::Publication
      expect(mags.first.code).to eq 'w21.1-E'
      expect(mags.first.name).to eq 'Watchtower (study edition) January 2021'
    end
  end

  describe '.meeting_workbooks' do
    it 'should return an array of publications according to the generation rules' do
      mags = described_class.meeting_workbooks(year: 2021)

      expect(mags.count).to be 6
      expect(mags.first).to be_an_instance_of LiteratureRequests::Publication
      expect(mags.first.code).to eq 'mwb21.01-E'
      expect(mags.first.name).to eq 'Our Christian Life and Ministry Meeting Workbook January-February 2021'
    end
  end
end

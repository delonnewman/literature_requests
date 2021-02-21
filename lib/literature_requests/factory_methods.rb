module LiteratureRequests
  module_function

  def congregation
    Congregation.new
  end

  def access_keys
    AccessKeyRepository.new
  end

  def requests
    RequestRecords.new
  end

  def generate_access_key_for(person_id)
    AccessKey[
      id:        SecureRandom.uuid,
      key:       SecureRandom.urlsafe_base64(64),
      person_id: person_id]
  end

  # TODO: move this into the database
  MAGAZINES = {
    w:  { name: ->(n, year) { "Watchtower (study edition) #{Date::MONTHNAMES[n]} #{year}" }, count: 12 },
    wp: { name: ->(n, year) { "Watchtower (public edition) No. #{n} #{year}" }, count: 3 },
    g:  { name: ->(n, year) { "Awake! No. #{n} #{year}" }, count: 3 },
  }

  def magazines(code:, year:, lang: 'E')
    mag = MAGAZINES.fetch(code.to_sym)
    mag[:count].times.map do |i|
      n = i + 1
      Publication[code: "#{code}#{year.to_s[-2, 2]}.#{n}-#{lang}", name: mag[:name][n, year]]
    end
  end

  def meeting_workbooks(year:, lang: 'E')
    12.times.each_slice(2).map do |(i, j)|
      n,  m  = i + 1, j + 1
      m1, m2 = Date::MONTHNAMES[n], Date::MONTHNAMES[m]
      padded = sprintf("%02d", n)
      Publication[
        code: "mwb#{year.to_s[-2, 2]}.#{padded}-#{lang}",
        name: "Our Christian Life and Ministry Meeting Workbook #{m1}-#{m2} #{year}"]
    end
  end

  def publications
    PublicationRepository.new
  end

  def intake_dashboard(access_id:, key:)
    IntakeDashboard.new(access_id, key)
  end
end

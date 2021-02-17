module LiteratureRequests
  module_function

  def congregation
    Congregation.new
  end

  def access_keys
    AccessKeyRepository.new
  end

  def generate_access_key_for(person_id)
    AccessKey[
      id:        SecureRandom.uuid,
      key:       SecureRandom.urlsafe_base64(64),
      person_id: person_id]
  end
end

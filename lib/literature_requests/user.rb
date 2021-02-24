module LiteratureRequests
  DB = db
  class User < Sequel::Model
    def password
      @password ||= BCrypt::Password.new(crypted_password)
    end

    def password=(string)
      @password = BCrypt::Password.create(string)
      self.crypted_password = @password
    end
  end
end

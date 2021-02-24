Sequel.migration do
  change do
    create_table? :users do
      primary_key :id
      String :displayname, null: false, index: true
      String :username, null: false, index: true
      String :email, index: true
      String :crypted_password
      String :salt
      FalseClass :admin, null: false, default: false, index: true
    end
  end
end

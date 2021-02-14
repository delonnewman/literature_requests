Sequel.migration do
  change do
    create_table? :groups do
      primary_key :id
      Integer :overseer_id, null: false, index: true
    end

    create_table? :people do
      primary_key :id
      foreign_key :group_id, :groups
      String :first_name, null: false, index: true
      String :last_name, null: false, index: true
      String :email, index: true
      FalseClass :publisher, null: false, default: true, index: true
      FalseClass :pioneer, null: false, default: false, index: true
      FalseClass :overseer, null: false, default: false, index: true
    end

    create_table? :literature do
      String :code, null: false, index: true
      String :name, null: false, index: true
    end

    create_table? :request_items do
      uuid :request_id, null: false, index: true
      String :literature_code, null: false, index: true
      Integer :status_code, null: false, index: true
      foreign_key :requester_id, :people
      Time :created_at, null: false, index: true
      Time :updated_at, null: false, index: true
    end
  end
end

Sequel.migration do
  change do
    create_table? :congregation do
      primary_key :id
      foreign_key :group_overseer_id, :congregation, on_delete: :set_null
      String :first_name, null: false, index: true
      String :last_name, null: false, index: true
      String :email, index: true
      FalseClass :pioneer, null: false, default: false, index: true
    end

    create_table? :publications do
      String :code, null: false, index: true, unique: true
      String :name, null: false, index: true
    end

    create_table? :access_keys do
      uuid :id, null: false, index: true
      String :key, null: false
      foreign_key :person_id, :congregation, on_delete: :cascade
    end

    create_table? :request_items do
      primary_key :item_id
      uuid :request_id, null: false, index: true
      String :publication_code, null: false, index: true
      Integer :quantity, null: false, index: true
      Integer :status_code, null: false, index: true
      foreign_key :requester_id, :congregation
      Time :created_at, null: false, index: true
      Time :updated_at, null: false, index: true
    end
  end
end

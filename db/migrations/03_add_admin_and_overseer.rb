Sequel.migration do
  change do
    alter_table :congregation do
      add_column :admin, FalseClass, default: false, null: false, index: true
      add_column :overseer, FalseClass, default: false, null: false, index: true
    end
  end
end

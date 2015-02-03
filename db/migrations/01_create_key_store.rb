Sequel.migration do
  change do

    create_table(:key_store) do
      column :private_key, 'bytea', null: true
      column :public_key, 'bytea', null: true
      String :key_id, primary_key: true
    end
  end
end

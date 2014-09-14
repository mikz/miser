Sequel.migration do
  change do
    run 'CREATE EXTENSION IF NOT EXISTS pgcrypto;'

    create_table(:credentials) do
      String :driver, primary_key: true
      column :credentials, 'bytea', null: false
      foreign_key :key_id, :key_store, null: false, type: :text
    end
  end
end

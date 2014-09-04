Sequel.migration do
  change do
    run 'CREATE EXTENSION IF NOT EXISTS pgcrypto;'

    create_table(:store) do
      String :driver, null: false
      index :driver, unique: true

      String :secure, null: false
    end
  end
end

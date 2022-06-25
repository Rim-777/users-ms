# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id, type: :Bignum, null: false
      column :email, 'character varying', null: false
      column :password_digest, 'character varying', null: false
      column :first_name, 'character varying'
      column :last_name, 'character varying'
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false

      index [:email], name: :index_users_on_email, unique: true
    end
  end
end

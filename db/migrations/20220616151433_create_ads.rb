# frozen_string_literal: true

Sequel.migration do # this is an example
  change do
    create_table(:ads) do
      primary_key :id, type: :Bignum, null: false
      column :user_id_ref, :Bignum, null: false
      column :title, 'character varying', null: false
      column :description, 'text', null: false
      column :city, 'character varying', null: false
      column :lat, 'double precision'
      column :lon, 'double precision'
      column :created_at, 'timestamp(6) without time zone', null: false
      column :updated_at, 'timestamp(6) without time zone', null: false

      index [:user_id_ref], name: :index_ads_on_user_id_ref
    end
  end
end

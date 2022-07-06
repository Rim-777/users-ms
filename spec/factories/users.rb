# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Timo' }
    last_name { 'Moss' }
    email
    password { '###qwerty123' }
  end
end

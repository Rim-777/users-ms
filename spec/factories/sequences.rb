# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) do |n|
    "email-#{n}@example.com"
  end
end

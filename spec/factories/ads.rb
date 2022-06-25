# frozen_string_literal: true

FactoryBot.define do
  sequence :user_id_ref do |n|
    n
  end

  factory :ad do
    title { 'Ad title' }
    description { 'Ad description' }
    city { 'City' }
    user_id_ref
  end
end

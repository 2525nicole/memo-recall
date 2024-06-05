# frozen_string_literal: true

FactoryBot.define do
  factory :memory do
    content { 'MyText' }
    category_id { 1 }
    user { nil }
  end
end

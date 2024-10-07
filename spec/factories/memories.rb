# frozen_string_literal: true

FactoryBot.define do
  factory :memory do
    content { '今日はこんな嬉しいことがありました。' }
    category_id { 1 }
    user
  end
end

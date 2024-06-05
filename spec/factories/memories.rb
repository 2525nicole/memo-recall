FactoryBot.define do
  factory :memory do
    content { "MyText" }
    category_id { 1 }
    user { nil }
  end
end

# frozen_string_literal: true

user = User.find_or_create_by!(email: 'test@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
  u.confirmed_at = Time.now
end

category = Category.find_or_create_by!(name: '嬉しかったこと', user: user)

# カテゴリーに紐づく思い出
Memory.find_or_create_by!(content: '今日はこんな嬉しいことがありました！', user: user, category: category)
# カテゴリーに紐づかない思い出
Memory.find_or_create_by!(content: 'カテゴリーなしの思い出', user: user, category: nil)

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'バリデーション' do
    it 'nameが空欄の場合は無効である' do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include('を入力してください')
    end

    it 'nameが15文字を超える場合は無効である' do
      category = build(:category, name: 'a' * 16)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include('は15文字以内で入力してください')
    end

    it 'nameが15文字以内の場合は有効である' do
      category = build(:category, name: 'a' * 15)
      expect(category).to be_valid
    end

    it 'ユーザーは作成済みのカテゴリーを2つ作成できない' do
      user = create(:user)
      create(:category, name: '同じ名前のカテゴリー', user:)
      duplicate_category = build(:category, name: '同じ名前のカテゴリー', user:)
      expect(duplicate_category).not_to be_valid
      expect(duplicate_category.errors[:name]).to include('はすでに存在します')
    end

    it '別のユーザーであれば同じ名前のカテゴリーを作成できる' do
      user1 = create(:user, email: 'user1@example.com')
      user2 = create(:user, email: 'user2@example.com')

      create(:category, name: '同じ名前のカテゴリー', user: user1)
      different_user_category = build(:category, name: '同じ名前のカテゴリー', user: user2)

      expect(different_user_category).to be_valid
    end
  end

  describe '#ransackable_attributes' do
    it 'ransackable_attributes' do
      expect(Category.ransackable_attributes).to eq(['id'])
    end
  end
end

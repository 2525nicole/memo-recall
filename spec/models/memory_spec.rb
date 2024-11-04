# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Memory, type: :model do
  let!(:confirm_user) { create(:user, confirmed_at: Time.current) }
  let(:valid_category) { create(:category, user: confirm_user) }

  describe '#ransackable_attributes' do
    it 'ransackable_attributes' do
      expect(Memory.ransackable_attributes).to eq(['id'])
    end
  end

  describe '#assign_category' do
    context '新しいカテゴリー名が渡された場合' do
      it 'カテゴリーが作成され、思い出に紐づけられる' do
        memory = build(:memory, user: confirm_user, new_category_name: '新しいカテゴリー')
        memory.save
        expect(memory.category.name).to eq('新しいカテゴリー')
      end
    end

    context '登録済みのカテゴリーIDが渡された場合' do
      it '登録済みのカテゴリーが思い出に紐づけられる' do
        memory = build(:memory, user: confirm_user, category: valid_category)
        memory.save
        expect(memory.category).to eq(valid_category)
      end
    end

    context '新しいカテゴリー名も登録済みのカテゴリーIDも渡されない場合' do
      it 'カテゴリーは思い出に紐づけられない' do
        memory = build(:memory, user: confirm_user, category: nil)
        memory.save
        expect(memory.category).to be_nil
      end
    end
  end

  describe '#validate_associated_category' do
    it 'カテゴリーが invalid の場合、エラーが追加される' do
      invalid_category = build(:category, name: nil, user: confirm_user)
      memory = build(:memory, user: confirm_user, category: invalid_category)
      memory.valid?

      expect(memory.errors[:base]).to include('カテゴリー名を入力してください')
    end

    it 'カテゴリーが valid の場合、エラーは追加されない' do
      valid_category = build(:category, user: confirm_user)
      memory = build(:memory, user: confirm_user, category: valid_category)
      memory.valid?

      expect(memory.errors[:base]).to be_empty
    end
  end
end

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

  describe '#valid_category?' do
    context 'category が nilの場合' do
      it 'true を返す' do
        memory = create(:memory, user: confirm_user, category: nil)
        expect(memory.valid_category?).to eq(true)
      end
    end

    context 'category が有効な場合' do
      it 'true を返す' do
        memory = create(:memory, user: confirm_user, category: valid_category)
        expect(memory.valid_category?).to eq(true)
      end
    end

    context 'category 無効な場合' do
      it 'false を返す' do
        category = build(:category, name: nil, user: confirm_user)
        memory = create(:memory, user: confirm_user, category:)
        expect(memory.valid_category?).to eq(false)
      end
    end
  end

  describe '#assign_category' do
    context '新しいカテゴリー名が渡された場合' do
      it 'カテゴリーが作成され、思い出に紐づけられる' do
        memory = build(:memory, user: confirm_user)

        category, category_errors = memory.assign_category({ new_category_name: '新しいカテゴリー' }, confirm_user)

        expect(category.name).to eq('新しいカテゴリー')
        expect(memory.category).to eq(category)
        expect(category_errors).to be_empty
      end

      it 'カテゴリーが invalid の場合、エラーが返される' do
        memory = build(:memory, user: confirm_user)
        _category, category_errors = memory.assign_category({ new_category_name: 'x' * 20 }, confirm_user)

        expect(category_errors).not_to be_empty
        expect(category_errors).to include('カテゴリー名は15文字以内で入力してください')
      end
    end

    context '登録済みのカテゴリーIDが渡された場合' do
      it '登録済みのカテゴリーが思い出に紐づけられる' do
        memory = build(:memory, user: confirm_user)
        _category, category_errors = memory.assign_category({ category_id: valid_category.id }, confirm_user)

        expect(memory.category).to eq(valid_category)
        expect(category_errors).to be_empty
      end
    end

    context '新しいカテゴリー名も登録済みのカテゴリーIDも渡されない場合' do
      it 'カテゴリーは思い出に紐づけられない' do
        memory = build(:memory, user: confirm_user)
        _category, category_errors = memory.assign_category({}, confirm_user)

        expect(memory.category).to be_nil
        expect(category_errors).to be_empty
      end
    end
  end
end

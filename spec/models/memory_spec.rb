# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Memory, type: :model do
  let!(:confirm_user) { create(:user, confirmed_at: Time.current) }

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
        category = create(:category, user: confirm_user)
        memory = create(:memory, user: confirm_user, category:)
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
end

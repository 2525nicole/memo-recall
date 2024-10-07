# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Memory, type: :model do
  describe 'バリデーション' do
    it 'contentが空欄の場合は無効である' do
      memory = build(:memory, content: nil)
      expect(memory).not_to be_valid
      expect(memory.errors[:content]).to include('を入力してください')
    end

    it 'contentが300文字を超える場合は無効である' do
      memory = build(:memory, content: 'a' * 301)
      expect(memory).not_to be_valid
      expect(memory.errors[:content]).to include('は300文字以内で入力してください')
    end

    it 'contentが300文字以内の場合は有効である' do
      memory = build(:memory, content: 'a' * 300)
      expect(memory).to be_valid
    end
  end

  describe '#ransackable_attributes' do
    it 'ransackable_attributes' do
      expect(Memory.ransackable_attributes).to eq(['id'])
    end
  end
end

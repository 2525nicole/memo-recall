# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#ransackable_attributes' do
    it 'ransackable_attributes' do
      expect(Category.ransackable_attributes).to eq(['id'])
    end
  end
end

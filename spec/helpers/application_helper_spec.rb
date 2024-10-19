# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#count_character' do
    it '正しいデータ属性とテキストを持つspanタグを返す。' do
      result = helper.count_character('memory_content', 300)
      expect(result).to include('data-character-counter-target="counter"')
      expect(result).to include('data-counter-for="memory_content"')
      expect(result).to include('現在 0/300 文字入力しています')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memories::Random', type: :system do
  let!(:confirm_user) { create(:user, confirmed_at: Time.current) }
  let!(:category) { create(:category, user: confirm_user) }

  before do
    sign_in confirm_user
  end

  describe '#show' do
    context '思い出の登録がない時' do
      it '「思い出がまだ登録されていません。」と表示される' do
        visit authenticated_root_path
        expect(page).to have_content '思い出がまだ登録されていません。'
      end
    end

    context '思い出の登録がある時' do
      it '登録済みの思い出のうち1つが表示される' do
        memories = create_list(:memory, 3, user: confirm_user, category:).each_with_index do |memory, index|
          memory.update(content: "思い出その#{index + 1}")
        end
        visit authenticated_root_path
        displayed_memory = find('#random_memory').text.split("\n").first
        expect(memories.map(&:content)).to include(displayed_memory)
      end
    end
  end
end

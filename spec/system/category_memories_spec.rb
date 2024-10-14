# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CategoryMemories', type: :system do
  let!(:confirm_user) { create(:user, confirmed_at: Time.current) }
  let(:category) { create(:category, user: confirm_user) }

  before do
    sign_in confirm_user
  end

  describe '#index' do
    context 'カテゴリーに紐づく思い出の登録がない場合' do
      it '「このカテゴリーに紐づく思い出がまだ登録されていません。」と表示される' do
        visit category_memories_path(category.id)
        expect(page).to have_content 'このカテゴリーに紐づく思い出がまだ登録されていません。'
      end
    end

    context 'カテゴリーに紐づく思い出の登録がある場合' do
      it 'カテゴリーに紐づく思い出と、その件数が表示される' do
        create(:memory, content: 'カテゴリーに紐づく思い出', user: confirm_user, category:)
        visit category_memories_path(category.id)
        expect(page).to have_content 'カテゴリーに紐づく思い出'
        expect(page).to have_content 'カテゴリー「嬉しかったこと」の思い出一覧（1件）'
      end
    end
  end
end

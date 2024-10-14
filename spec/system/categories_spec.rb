# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memories', type: :system do
  let!(:confirm_user) { create(:user, confirmed_at: Time.current) }

  before do
    sign_in confirm_user
  end

  describe '#index' do
    context 'カテゴリーの登録がない場合' do
      it '「カテゴリーがまだ登録されていません。」と表示される' do
        visit categories_path
        expect(page).to have_content 'カテゴリーがまだ登録されていません。'
      end
    end

    context 'カテゴリーの登録がある場合' do
      it '登録済みのカテゴリーが表示される' do
        create(:category, user: confirm_user)
        visit categories_path
        expect(page).to have_content '嬉しかったこと(0件)'
      end
    end
  end

  describe '#create' do
    it '登録したカテゴリーが追加される' do
      visit categories_path
      click_link '＋カテゴリーを登録する'
      fill_in 'category[name]', with: '楽しかったこと'
      click_button '保存する'
      expect(page).to have_content 'カテゴリーを作成しました。'
      expect(page).to have_content '楽しかったこと'
    end

    context '登録済みのカテゴリー名を入力した場合' do
      it '「カテゴリー名はすでに存在します」と表示される' do
        create(:category, user: confirm_user)
        visit categories_path
        click_link '＋カテゴリーを登録する'
        fill_in 'category[name]', with: '嬉しかったこと'
        click_button '保存する'
        expect(page).to have_content 'カテゴリー名はすでに存在します'
      end
    end

    context 'カテゴリー名を入力していない場合' do
      it '「カテゴリー名を入力してください」と表示される' do
        create(:category, user: confirm_user)
        visit categories_path
        click_link '＋カテゴリーを登録する'
        fill_in 'category[name]', with: ''
        click_button '保存する'
        expect(page).to have_content 'カテゴリー名を入力してください'
      end
    end
  end

  describe '#update' do
    it 'カテゴリーが更新できる' do
      create(:category, name: '更新する前のカテゴリー', user: confirm_user)
      visit categories_path
      click_link '編集する'
      fill_in 'category[name]', with: '更新した後のカテゴリー'
      click_button '保存する'
      expect(page).to have_content 'カテゴリーを更新しました'
      expect(page).to have_content '更新した後のカテゴリー'
    end
  end

  describe '#destroy' do
    it 'カテゴリーが削除できる' do
      create(:category, user: confirm_user)
      visit categories_path
      click_link '編集する'
      click_link 'このカテゴリーを削除する'
      expect(page.accept_confirm).to eq "カテゴリー「嬉しかったこと」を削除しますか？\n紐づけられている思い出は「カテゴリー登録なし」になります。"
      expect(page).to have_content 'カテゴリーを削除しました'
      expect(page).not_to have_content '嬉しかったこと'
    end
  end
end

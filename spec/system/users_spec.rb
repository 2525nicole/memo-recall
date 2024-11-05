# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:email) { 'test@example.com' }
  let(:password) { 'test1234' }
  let!(:confirm_user) { create(:user, confirmed_at: Time.current) }
  let!(:not_confirm_user) { create(:user, email: 'not_confirm@example.com') }

  describe '新規登録' do
    it '新規登録ができる' do
      visit root_path
      click_link '新規登録', match: :first
      fill_in 'Eメール', with: email
      fill_in 'パスワード', with: password
      fill_in 'パスワード（確認用）', with: password
      click_button '登録する'
      expect(page).to have_content('本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。')

      User.find_by(email:).confirm

      visit new_user_session_path
      fill_in 'Eメール', with: email
      fill_in 'パスワード', with: password
      click_button 'ログイン'
      expect(page).to have_content('ログインしました。')
    end

    it '登録済みのメールアドレスでは新規登録できない' do
      visit root_path
      click_link '新規登録', match: :first
      fill_in 'Eメール', with: confirm_user.email
      fill_in 'パスワード', with: 'diffarent_password'
      fill_in 'パスワード（確認用）', with: 'diffarent_password'
      click_button '登録する'
      expect(page).to have_content('Eメールはすでに存在します')
    end
  end

  describe 'ログイン' do
    it '登録済みのユーザーはログインできる' do
      visit new_user_session_path
      fill_in 'Eメール', with: confirm_user.email
      fill_in 'パスワード', with: confirm_user.password
      click_button 'ログイン'
      expect(page).to have_content('ログインしました。')
    end

    it '誤った情報ではログインできない' do
      visit new_user_session_path
      fill_in 'Eメール', with: confirm_user.email
      fill_in 'パスワード', with: 'wrong_password'
      click_button 'ログイン'
      expect(page).to have_content('Eメールまたはパスワードが違います。')
    end
  end

  describe 'パスワード再設定' do
    it 'パスワード再設定メールが送信される' do
      visit new_user_password_path
      fill_in 'Eメール', with: confirm_user.email
      click_button '送信する'
      expect(page).to have_content('パスワードの再設定について数分以内にメールでご連絡いたします。')
    end
  end

  describe 'アカウント確認メールの再送' do
    it 'アカウント確認メールが再送される' do
      visit new_user_confirmation_path
      fill_in 'Eメール', with: not_confirm_user.email
      click_button '送信する'
      expect(page).to have_content('アカウントの有効化について数分以内にメールでご連絡します。')
    end
  end

  describe 'アカウント設定' do
    before do
      sign_in confirm_user
    end

    it 'ユーザーがメールアドレスを変更できる' do
      visit edit_user_registration_path
      fill_in 'Eメール', with: 'updated_user@example.com'
      fill_in '現在のパスワード', with: confirm_user.password
      click_button '更新する'
      expect(page).to have_content('アカウント情報を変更しました。本人確認用メールより確認をおこなってください。')
    end

    it 'ユーザーがパスワードを変更できる' do
      visit edit_user_registration_path
      fill_in 'Eメール', with: 'updated_user@example.com'
      fill_in 'パスワード', with: 'new_password'
      fill_in 'パスワード（確認用）', with: 'new_password'
      fill_in '現在のパスワード', with: confirm_user.password
      click_button '更新する'
      expect(page).to have_content('アカウント情報を変更しました。')
    end
  end

  describe 'ログアウト' do
    before do
      sign_in confirm_user
    end

    it 'ユーザーがログアウトできる' do
      visit root_path
      find('i.fa-bars').click
      click_button 'ログアウト'
      expect(page).to have_content('ログアウトしました。')
    end
  end

  describe 'アカウント削除' do
    before do
      sign_in confirm_user
    end

    it 'ユーザーがアカウント削除できる' do
      visit edit_user_registration_path
      click_button 'アカウントを削除する'
      expect(page.accept_confirm).to eq 'アカウントを削除すると登録されているデータが全て失われます。本当によろしいですか？'
      expect(page).to have_content('アカウントを削除しました。またのご利用をお待ちしております。')
    end
  end
end

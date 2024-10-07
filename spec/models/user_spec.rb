# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録のバリデーション' do
    describe 'メールアドレス' do
      context '有効なメールアドレスの場合' do
        it 'ユーザー登録に成功する' do
          expect(build(:user)).to be_valid
        end
      end

      context '無効なメールアドレスの場合' do
        it 'ユーザー登録に失敗する' do
          user = build(:user, email: 'invalid_email')
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include('は不正な値です')
        end
      end

      context 'メールアドレスが未入力の場合' do
        it 'ユーザー登録に失敗する' do
          user = build(:user, email: nil)
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include('を入力してください')
        end
      end

      context '登録済みのメールアドレスの場合' do
        it 'ユーザー登録に失敗する' do
          create(:user)
          user = build(:user, email: 'test@example.com')
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include('はすでに存在します')
        end
      end
    end

    describe 'パスワード' do
      context '有効なパスワードの場合' do
        it 'ユーザー登録に成功する' do
          expect(build(:user)).to be_valid
        end
      end

      context '無効なパスワードの場合' do
        it 'ユーザー登録に失敗する' do
          user = build(:user, password: 'test')
          expect(user).not_to be_valid
          expect(user.errors[:password]).to include('は6文字以上で入力してください')
        end
      end

      context 'パスワードが未入力の場合' do
        it 'ユーザー登録に失敗する' do
          user = build(:user, password: nil)
          expect(user).not_to be_valid
          expect(user.errors[:password]).to include('を入力してください')
        end
      end
    end
  end
end

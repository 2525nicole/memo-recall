# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memories', type: :system do
  let!(:confirm_user) { create(:user, confirmed_at: Time.current) }
  let!(:category) { create(:category, user: confirm_user) }

  before do
    sign_in confirm_user
  end

  describe '#random' do
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

  describe '#index' do
    context '思い出の登録がない時' do
      it '「思い出がまだ登録されていません。」と表示される' do
        visit memories_path
        expect(page).to have_content '思い出がまだ登録されていません。'
      end
    end

    context '思い出の登録がある時' do
      it '登録済みの思い出が表示される' do
        create(:memory, user: confirm_user, category:)
        visit memories_path
        expect(page).to have_content '今日はこんな嬉しいことがありました。'
      end
    end
  end

  describe '#create' do
    context '登録するページ別' do
      context '思い出一覧ページでの登録' do
        it '登録した思い出が追加される' do
          visit memories_path
          find('a[href="/memories/new"]').click
          fill_in 'memory[content]', with: '思い出一覧ページで登録する思い出'
          click_button '保存する'
          expect(page).to have_content '思い出を記録しました。'
          expect(page).to have_content '思い出一覧ページで登録する思い出'
        end
      end

      context 'ランダム思い出表示ページでの登録' do
        it 'flashメッセージに思い出一覧ページのリンクが表示される' do
          visit authenticated_root_path
          find('a[href="/memories/new"]').click
          fill_in 'memory[content]', with: 'TOPページで登録する思い出'
          click_button '保存する'
          expect(page).to have_link '思い出を記録しました。（思い出の一覧を見る）', href: memories_path
        end

        context '思い出の登録が初めての場合' do
          it '登録した思い出が表示される' do
            visit authenticated_root_path
            find('a[href="/memories/new"]').click
            fill_in 'memory[content]', with: 'TOPページで登録する1つ目の思い出'
            click_button '保存する'
            expect(page).to have_link '思い出を記録しました。（思い出の一覧を見る）', href: memories_path
            expect(page).to have_content 'TOPページで登録する1つ目の思い出'
          end
        end
      end

      context 'カテゴリー別思い出表示ページでの登録' do
        context 'そのカテゴリーに紐づかない思い出を登録する場合' do
          it 'flashメッセージに思い出一覧ページのリンクが表示される' do
            visit category_memories_path(category.id)
            find('a[href="/memories/new"]').click
            fill_in 'memory[content]', with: 'カテゴリー別思い出一覧ページで登録する思い出'
            click_button '保存する'
            expect(page).to have_link '思い出を記録しました。（思い出の一覧を見る）', href: memories_path
          end
        end

        context 'そのカテゴリーに紐づく思い出を登録する場合' do
          it '登録した思い出が追加され、件数にも追加される' do
            visit category_memories_path(category.id)
            find('a[href="/memories/new"]').click
            fill_in 'memory[content]', with: 'カテゴリー別思い出一覧ページで登録する思い出'
            select '嬉しかったこと', from: 'memory[category_id]'
            click_button '保存する'
            expect(page).to have_link '思い出を記録しました。（思い出の一覧を見る）', href: memories_path
            expect(page).to have_content 'カテゴリー別思い出一覧ページで登録する思い出'
            expect(page).to have_content 'カテゴリー「嬉しかったこと」の思い出一覧（1件）'
          end
        end
      end

      context 'カテゴリーに紐づく思い出の登録' do
        it 'カテゴリー別思い出一覧ページの件数が増える' do
          visit memories_path
          find('a[href="/memories/new"]').click
          fill_in 'memory[content]', with: 'カテゴリーに紐づく思い出'
          select '嬉しかったこと', from: 'memory[category_id]'
          click_button '保存する'

          visit categories_path
          expect(page).to have_content '嬉しかったこと(1件)'
        end
      end
    end

    context '思い出本文を入力していない場合' do
      it '「内容を入力してください」と表示される' do
        visit memories_path
        find('a[href="/memories/new"]').click
        fill_in 'memory[content]', with: ''
        click_button '保存する'
        expect(page).to have_content '内容を入力してください'
      end
    end
  end

  describe '#update' do
    context '思い出一覧ページでの更新' do
      it '更新後の思い出が表示される' do
        memory = create(:memory, content: '更新する前の思い出', user: confirm_user, category:)
        visit memories_path
        find("a[href='/memories/#{memory.id}/edit']").click
        fill_in 'memory[content]', with: '更新した後の思い出'
        click_button '保存する'
        expect(page).to have_content '思い出を更新しました'
        expect(page).to have_content '更新した後の思い出'
      end
    end

    context 'カテゴリー別思い出表示ページでの更新' do
      context 'カテゴリーに変更がない場合' do
        it '更新後の思い出が表示される' do
          memory = create(:memory, content: '更新する前の思い出', user: confirm_user, category:)
          visit category_memories_path(category.id)
          find("a[href='/memories/#{memory.id}/edit']").click
          fill_in 'memory[content]', with: '更新した後の思い出'
          click_button '保存する'
          expect(page).to have_content '思い出を更新しました'
          expect(page).to have_content '更新した後の思い出'
          expect(page).to have_content 'カテゴリー「嬉しかったこと」の思い出一覧（1件）'
        end
      end

      context 'カテゴリーに変更がある場合' do
        it '更新した思い出は表示されず、件数から除かれる' do
          memory = create(:memory, content: '更新する前の思い出', user: confirm_user, category:)
          visit category_memories_path(category.id)
          find("a[href='/memories/#{memory.id}/edit']").click
          fill_in 'memory[content]', with: '更新した後の思い出'
          select 'カテゴリーなし', from: 'memory[category_id]'
          click_button '保存する'
          expect(page).to have_content '思い出を更新しました'
          expect(page).not_to have_content '更新した後の思い出'
          expect(page).to have_content 'カテゴリー「嬉しかったこと」の思い出一覧（0件）'
        end
      end
    end
  end

  describe '#destroy' do
    context '削除するページ別' do
      context '思い出一覧ページでの削除' do
        it '削除した思い出は表示されない' do
          memory = create(:memory, content: '思い出一覧ページで削除する思い出', user: confirm_user, category:)
          visit memories_path
          find("a[href='/memories/#{memory.id}/edit']").click
          click_link 'この思い出を手放す（削除する）'
          expect(page.accept_confirm).to eq "この思い出を手放しますか？\n手放した思い出は一覧から削除されます。"
          expect(page).to have_content '思い出を手放しました。'
          expect(page).not_to have_content '思い出一覧ページで削除する思い出'
        end
      end

      context 'カテゴリー別思い出表示ページでの登録' do
        it '削除した思い出は表示されず、件数から除かれる' do
          memory = create(:memory, content: 'カテゴリー別思い出一覧ページで削除する思い出', user: confirm_user, category:)
          visit category_memories_path(category.id)
          find("a[href='/memories/#{memory.id}/edit']").click
          click_link 'この思い出を手放す（削除する）'
          expect(page.accept_confirm).to eq "この思い出を手放しますか？\n手放した思い出は一覧から削除されます。"
          expect(page).to have_content '思い出を手放しました。'
          expect(page).not_to have_content 'カテゴリー別思い出一覧ページで削除する思い出'
          expect(page).to have_content 'カテゴリー「嬉しかったこと」の思い出一覧（0件）'
        end
      end
    end

    context 'カテゴリーに紐づく思い出の削除' do
      it 'カテゴリー別思い出一覧ページの件数が減る' do
        memory = create(:memory, content: '削除する思い出', user: confirm_user, category:)
        visit memories_path
        find("a[href='/memories/#{memory.id}/edit']").click
        click_link 'この思い出を手放す（削除する）'
        expect(page.accept_confirm).to eq "この思い出を手放しますか？\n手放した思い出は一覧から削除されます。"

        visit categories_path
        expect(page).to have_content '嬉しかったこと(0件)'
      end
    end
  end
end

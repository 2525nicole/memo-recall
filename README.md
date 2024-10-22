# Memo Recall

![README用のロゴ](https://github.com/user-attachments/assets/78e0f8e2-1ef7-47b3-be10-9e535d24fe19)

## 概要

Memo Recallは、思い出記録サービスです。<br>
いつでも簡単に思い出を記録したり、振り返ることができます。

思い出はカテゴリーと紐づけて登録できます。<br>
カテゴリーごとに思い出を表示したり、思い出の整理ができるので、<br>
いつでも前向きに過去を振り返ることができます。

トップページでは、登録済みの思い出がランダムに表示されます。<br>
Memo Recallを使えば日々の忙しさで忘れかけていた大切な思い出と
思わぬ再会ができるかもしれません。

## URL

https://memo-recall.fly.dev/

## 使い方

### アカウント登録

メールアドレスと任意のパスワードを設定し、登録してください。

<img width="50%" alt="アカウント登録" src="https://github.com/user-attachments/assets/fb050c07-291c-4d1c-ba85-32346fe39c3e">

### 思い出の登録

- 思い出の本文を入力してください。
- カテゴリー名を入力または選択することで、思い出とカテゴリーを紐づけて登録できます。

<img width="50%" alt="思い出の登録" src="https://github.com/user-attachments/assets/852c98b5-4884-46f8-a262-c88aee6ba886">

### カテゴリーの登録

- カテゴリー一覧ページからも登録できます。

<img width="50%" alt="カテゴリーの登録" src="https://github.com/user-attachments/assets/ad893ea3-1440-4e86-b030-20b6840ccc43">

### 思い出を振り返る

#### トップページ

- ログイン後のトップページでは、思い出がランダムで表示されます。
- 「もっと見る」を押して、さらに他の思い出を呼び出すこともできます。
  <img width="50%" alt="トップページ" src="https://github.com/user-attachments/assets/b13bca01-6dc9-4a03-9c57-9889b80acdab">

#### 思い出一覧ページ

- 思い出一覧ページでは、すべての思い出が表示されます。
  <img width="50%" alt="思い出一覧ページ" src="https://github.com/user-attachments/assets/b3210095-3e55-4138-9925-2c8786ce4c0b">

#### カテゴリー別の思い出一覧ページ

- カテゴリー別の思い出一覧ページでは、特定のカテゴリーに紐づく思い出が表示されます。
  <img width="50%" alt="カテゴリー別思い出一覧ページ" src="https://github.com/user-attachments/assets/149c3246-835d-4eca-a119-2d0a401845a4">

## 開発環境

- Ruby 3.3.0
- Ruby on Rails 7.1.3.3
- Hotwire

## 開発のセットアップと起動

- セットアップ

```
$ git clone https://github.com/2525nicole/memo-recall.git
$ cd memo-recall
$ bin/setup
```

- 起動

```
$ bin/dev
```

## Lint/ Test

- Lint

```
$ bin/lint
```

- Test

```
$ bundle exec rspec
```

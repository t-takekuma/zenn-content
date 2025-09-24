# Zenn Content

このリポジトリは **Zenn の記事を GitHub で管理し、公開**するためのオレオレワークスペースです。    

## 目的

- Zenn 記事管理・投稿管理を GitHub で実施
    - ローカルでプレビュー→PRレビュー→main へマージ→Zennと自動同期の流れを定着
- ローカルのGit HookとGitHub Actionsの二段構えで、秘密情報の誤コミットやリンク切れを検知する

## 技術要素

- Git/GitHub：バージョン管理・PR レビュー・保護ブランチ
- Git Hooks（pre-commit）：ローカルで秘密文字列を検知（tools/pre-commit.sh）
- GitHub Actions：gitleaksによるシークレット検査、Markdown リンクチェック、Node 実行環境固定、Dependabot
- Zenn CLI：npx zenn previewでローカルプレビュー、new:article/new:bookの雛形生成
- EditorConfig：改行・インデント統一
- Git Attributes：EOL正規化、private/** を配布除外
- Node/npm：.nvmrcでNodeバージョン固定（推奨: LTS）
- （任意）Git LFS：大きな画像アセットの管理

## 使い方

前提：Zenn側でGitHub連携を有効化済み（Zennの「GitHub連携」から当該リポジトリを登録）。

1. 記事を作る
- 新規作成：npx zenn new:articleまたは npx zenn new:book
- 作成先は articles/ または books/ に自動配置されます。

2. ローカルで確認する
- npx zenn previewを実行→ブラウザで内容を確認。

3. 公開する
- フロントマターのpublished: trueを設定し、mainブランチへマージしてpush。
- Zenn が GitHub から最新を取得し、公開状態に反映されます。

4. 画像や図版
- 記事から参照する画像はimages/ に置き、相対パスで参照。
- Mermaid/PlantUMLの元データは docs/ に置き、必要に応じて画像を書き出して images/ へ。

## ディレクトリ構成

zenn-content/
├─ articles/            # Zenn 記事（Zenn が読む）
├─ books/               # Zenn 本  （Zenn が読む）
├─ images/              # 記事が参照する公開用画像
├─ docs/                # 図の元データ（Mermaid/PlantUML 等）や設計素材
├─ notes/               # 公開しない研究メモや下書き（Zenn は読まない）
├─ tools/
│  └─ pre-commit.sh     # 秘密検知（Git pre-commit フックの本体）
├─ scripts/
│  └─ scan-secrets.sh   # 手動で回す秘密スキャン
├─ private/             # 緊急避難的に実値を置く仮置き（常時 .gitignore）
├─ .github/
│  ├─ workflows/        # CI 定義（gitleaks, md link check, node env など）
│  └─ mlc-config.json   # リンクチェッカ設定
├─ .editorconfig        # 編集統一
├─ .gitattributes       # EOL 正規化・配布除外
├─ .git-blame-ignore-revs # 一括整形コミットの blame 除外
├─ .nvmrc               # Node バージョン固定
├─ package.json         # zenn-cli など（npx でも可）
└─ README.md

## 各ディレクトリ／ファイルの目的と関連知識

articles/・books/
- 目的：Zennに公開されるMarkdown原稿の唯一の置き場。Zennはここだけ読む
- 関連知識：Zenn CLI（作成・プレビュー）、GitHub（同期）

images/
- 目的：記事が参照する最終画像（PNG/JPEG/SVG など）を集約
- 関連知識：Git（Git LFS？）

docs/
- 目的：図や図版の元データ・設計素材の保管
- 関連知識：Mermaid/PlantUML/任意の作図ツール？

notes/
- 目的：公開しない研究メモ・調査ログ・貼り付け用テキストの保管
- 関連知識：md

private/
- 目的：隠すべき実値（鍵・証明書・実ドメイン等）の配置箇所。常時ignore

.github/workflows/*
- 目的：CI、公開物の健全性確認
- ci-security.yml：gitleaksで秘密検査
- ci-links.yml：Markdownのリンク切れ検査
- ci-node.yml ：Node実行環境の固定検証（将来の自動化の土台？）
- 関連知識：GitHub Actions/gitleaks/markdown-link-check/actions/setup-node/Dependabot

.editorconfig
- 目的：改行コード・インデント・末尾改行等を横断統一し、差分ノイズを削減
- 関連知識：EditorConfig

.gitattributes
- 目的：EOL 正規化、画像のバイナリ扱い、private/**の配布除外（export-ignore）
- 関連知識：Git Attributes

.git-blame-ignore-revs
- 目的：一括整形など意味のない巨大差分をblameから除外して原因追跡を容易に
- 関連知識：Git（blame --ignore-revs-file）

.nvmrc
- 目的：Node の実行バージョン固定（再現性確保）
- 関連知識：Node/nvm

package.json
- 目的：zenn-cli・markdownlint等の実行スクリプトを束ねる（npx でも可）
- 関連知識：npmスクリプト

## ブランチ運用と公開フロー

- main：公開の唯一ソース。Zenn同期対象。
- 作業方針：feature ブランチ→PR（CI 通過）→ main へマージ。
- 公開の条件：対象ファイルのフロントマター published: true。
- 下書き：published: false のまま main に置けます（Zenn の下書き扱い）。

望ましさ：mainは保護ブランチ（レビュー必須）にし、PRベースで公開します。

## 初回セットアップ

1. Node：.nvmrcに合わせてnvm use
2. Zenn CLI：npx zenn previewが動けばOK（固定したい場合 devDependencies 追加）
3. Git Hook：tools/pre-commit.shを.git/hooks/pre-commitにリンク
4. Zenn連携：Zennのアカウント設定から当該GitHubリポジトリを連携

## よく使うコマンド

- プレビュー：npx zenn preview
- 記事作成：npx zenn new:article
- 本作成：npx zenn new:book
- 手動シークレット検査：bash scripts/scan-secrets.sh

## 秘密情報の扱い

- 実IP/実ドメイン/鍵・証明書/APIトークン等はコミット禁止。
- どうしても必要なファイルはprivate/（常時 ignore）。

## 変更履歴の責任分離

- 一括整形コミットはハッシュを .git-blame-ignore-revs に追記。
- 開発端末やエディタ差分を .editorconfig + .gitattributes で吸収。

## 資産集積のための指針（Zenn 以外）

- 公開予定のない素材・調査メモは notes/ に集約（Zenn の公開面に影響しないため）。
- 図の元データは docs/、書き出した最終画像は images/ へ。
- 大容量ファイルはGit LFS利用を検討。

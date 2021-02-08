[English](README.md) | [日本語](README_JA.md)

<h1 align="center">😄 gitmoji-semver 🚀</h1>

<p align="center">
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://gitmoji.carloscuesta.me">
    <img src="https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg?style=flat-square" alt="Gitmoji">
  </a>
  <a href="https://github.com/semantic-release/semantic-release">
    <img src="https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg" alt="semantic-release">
  </a>
</p>

<p align="center">
😆 gitmojiでコミットするだけで、セマンティックバージョニングによるオートバージョニングとgithubへのオートリリースが可能になります。
</p>



| 自動バージョニングとgithubへのリリース ([example](https://github.com/nkmr-jp/gitmoji-semver-sample/releases/tag/v4.0.0)) |
|--|
| ![image](https://user-images.githubusercontent.com/8490118/107201108-e60a9500-6a3b-11eb-875b-76b0efe2622e.png) |


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [自動リリースの方法](#自動リリースの方法)
  - [手順 1: `.semver.yml` をリポジトリのルートに追加](#手順-1-semveryml-をリポジトリのルートに追加)
  - [手順 2: `release.yml` を `.github/workflows/` に追加](#手順-2-releaseyml-を-githubworkflows-に追加)
  - [手順 3: コミットしてプッシュ](#手順-3-コミットしてプッシュ)
- [Macでの使用方法 (オプション)](#macでの使用方法-オプション)
  - [インストール](#インストール)
  - [使い方](#使い方)
- [参照](#参照)

<!-- /code_chunk_output -->

## 自動リリースの方法

**GithubActionsを使います。所要時間3分**。

ファイルを2つ追加するだけで準備は完了です。自分のGithubリポジトリで気軽に試してみてください。

### 手順 1: `.semver.yml` をリポジトリのルートに追加

example: [./.semver.yml](.semver.yml)

```yml
# .semver.yml

# Release Branches
branches: [ master, main ]

# gitmoji semver settings
# You can override the default values to suit your project.
semver:
  #  minor:
  #    - lipstick
  #  patch:
  #    - art
  #  none: # gitmoji.json "semver": null is convert to none
  #    - pencil2
  ignore: # not add in release-template.hbs
    - construction
```

### 手順 2: `release.yml` を `.github/workflows/` に追加

```yml
# .github/workflows/release.yml

name: Release
on:
  push:
    branches:
      - master
      - main
jobs:
  release:
    name: Release
    runs-on: ubuntu-18.04
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Setup Node.js
        uses: actions/setup-node@v1
        with:
          node-version: 12
      - name: Install jq yq
        run: |
          sudo wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O /usr/bin/jq &&\
          sudo chmod +x /usr/bin/jq
          sudo pip install yq
          jq --version
          yq --version
      - name: Install gitmoji-semver
        run: |
          git clone https://github.com/nkmr-jp/gitmoji-semver -b v2.0.0
      - name: Generate semantic-release configs
        working-directory: ./gitmoji-semver
        run: |
          make scaffold F=../.semver.yml O=..
      - name: Release
        working-directory: ./.release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          npm install
          npx semantic-release
```

### 手順 3: コミットしてプッシュ

```sh
git add .
git commit -m ":sparkles: Introduce new features."
git push
```

:tada: 終了です。Githubリポジトリのリリースページを確認してみましょう。

## Macでの使用方法 (オプション)

### インストール

`curl`, `jq`, `yq` と `node` コマンドが必要です。

```sh
brew install curl yq jq

yq --version
# yq 2.10.1
jq --version
# jq-1.6
node --version
# v13.14.0 # Probably works in other versions too.

# Install
git clone https://github.com/nkmr-jp/gitmoji-semver
```

### 使い方

```sh
cd ./gitmoji-semver
make help
```

## 参照

- [Add a "semver" field for each emoji #429](https://github.com/carloscuesta/gitmoji/issues/429)
- [gitmoji | An emoji guide for your commit messages](https://gitmoji.carloscuesta.me/)
- [GitHub - semantic-release/semantic-release](https://github.com/semantic-release/semantic-release)
- [GitHub - momocow/semantic-release-gitmoji](https://github.com/momocow/semantic-release-gitmoji)
- [Semantic Versioning 2.0.0 | Semantic Versioning](https://semver.org/)
- [Introduction to SemVer](https://blog.greenkeeper.io/introduction-to-semver-d272990c44f2)


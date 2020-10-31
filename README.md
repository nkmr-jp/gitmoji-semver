<h1 align="center">Welcome to gitmoji-semver 👋</h1>

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


> You can do easily Semver Release automatically by just committing with gitmoji.  ( [like this](https://github.com/nkmr-jp/gitmoji-semver/releases) )
 
- A simple script to add the semver field to [gitmojis.json](https://github.com/carloscuesta/gitmoji/blob/master/src/data/gitmojis.json).
    - Generate the files `gitmojis.json` with the semver field added.
    - I referred to this issue. ( [Add a "semver" field for each emoji #429](https://github.com/carloscuesta/gitmoji/issues/429) )
- Automate versioning and release with GithubActions and [semantic-release](https://github.com/semantic-release/semantic-release).

## Run in Github Actions

The following steps will automate versioning and releasing with gitmoji using GithubActions.
You only need to add two files, and you're ready to go. Feel free to try it out in your own Github repository. (**Estimated time: 3 minutes**)

### Step 1: Create `.semver.yml` to your Repository root

example: [./.semver.yml](.semver.yml)

```yml
# .semver.yml

# Release Branches
branches: [ master, main ]

# gitmoji semver settings (default is none)
semver:
  major:
    - boom      # Introduce breaking changes.
  minor:
    - sparkles  # Introduce new features.
  patch:
    - bug           # Fix a bug.
    - ambulance     # Critical hotfix.
    - green_heart   # Fix CI Build.
  none:
    - memo      # Add or update documentation.

  # Prevents it from appearing in Github's Release.
  ignore:
    - construction  # Work in progress.
```

### Step 2: Create `release.yml` to `.github/workflows/` 

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
          git clone https://github.com/nkmr-jp/gitmoji-semver -b v1.4.1
      - name: Generate semantic-release configs
        working-directory: ./gitmoji-semver
        run: |
          make scaffold V=v3.0.0 F=../.semver.yml O=..
      - name: Release
        working-directory: ./.release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          npm install
          npx semantic-release
```

### Step 3: Commit and Push
```sh
git add .
git commit -m ":construction_worker: Add Release settings by https://github.com/nkmr-jp/gitmoji-semver"
git push
```

Check out the release in your Github Repository.

### If you want to run locally

There will not be an actual Release.You can see how it works.

```sh
brew install act
act -P ubuntu-18.04=nektos/act-environments-ubuntu:18.04 # ※ 16GB docker image
```

## Run in Mac

### Install
require `curl`, `jq`, `yq` and `node` command.

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

### Usage
```sh
cd ./gitmoji-semver
make help

# Usage:
#     make COMMAND [Options]
# 
# Commands:
#     gen         Generate gitmojis.json with semver field (alias: g)
#     list        Show generated gitmojis.json (alias: l)
#     scaffold    Generate semantic-release setting files (alias: s)
# 
# Options:
#     V=<version>         Specify the base gitmoji version
#     F=<filepath>        Specify semver.yml file path
#     O=<output dir>      Specify semantic-release setting files output directory
# 
# Examples:
#     make gen V=v3.0.0 F=./semver.yml
#     make list
#     make scaffold V=v3.0.0 F=./.semver.yml O=./.playground
```

## Reference

If you want to customize, please refer to the following document.

- [GitHub - semantic-release/semantic-release](https://github.com/semantic-release/semantic-release)
- [GitHub - momocow/semantic-release-gitmoji](https://github.com/momocow/semantic-release-gitmoji)
- [gitmoji | An emoji guide for your commit messages](https://gitmoji.carloscuesta.me/)
- [Semantic Versioning 2.0.0 | Semantic Versioning](https://semver.org/)
- [Introduction to SemVer](https://blog.greenkeeper.io/introduction-to-semver-d272990c44f2)
- [Add a "semver" field for each emoji #429](https://github.com/carloscuesta/gitmoji/issues/429)

## Author

👤 **nkmr-jp**


## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_

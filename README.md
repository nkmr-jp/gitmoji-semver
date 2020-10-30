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


> A script to add the semver field to gitmojis.json, and generate semantic-release setting files.


- A simple script to add the semver field to [gitmojis.json](https://github.com/carloscuesta/gitmoji/blob/master/src/data/gitmojis.json).
- Generate the files `gitmojis.json` with the semver field added.
- You can easily change the configuration of semver in [./semver.yml](./semver.yml) .
- You can easily set up [semantic-release](https://github.com/semantic-release/semantic-release) and GithubActions to your project. 
  - It can do Semver Release automatically by just committing with gitmoji. ( [like this](https://github.com/nkmr-jp/gitmoji-semver/releases) )


## Prepare
require `curl`, `jq`, `yq` and `node` command.

```sh
# Install
brew install curl yq jq

yq --version
# yq 2.10.1
jq --version
# jq-1.6

node --version
# v13.14.0 # Probably works in other versions too. 
```

## Install

```sh
git clone https://github.com/nkmr-jp/gitmoji-semver 
```

## Usage
```sh
cd ./gitmoji-semver
make help
```
![image](https://user-images.githubusercontent.com/8490118/97711943-179cc780-1b01-11eb-935f-951956cfb18c.png)

### Edit semver.yml for your project

[./semver.yml](./semver.yml)

```yml
semver:
  major: [ boom ]
  minor: [ sparkles ]
  patch: [ bug, ambulance ]
```


## Reference
- https://github.com/carloscuesta/gitmoji/issues/429

## Author

👤 **nkmr-jp**


## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_

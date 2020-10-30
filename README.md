# gitmoji-semver

- A simple script to add the semver field to [gitmojis.json](https://github.com/carloscuesta/gitmoji/blob/master/src/data/gitmojis.json).
- Generate the files `gitmojis.json` and `gitmojis.yml` with the semver field added.
- You can easily change the configuration of semver in [./semver.yml](./semver.yml) .

## Prepare
require `curl`, `jq`, `yq` and `node` command.

```sh
# Install
$ brew install curl yq jq
```

```sh
# Probably works in other versions too. 
$ node --version
v13.14.0 
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

## Edit semver.yml for your project

[./semver.yml](./semver.yml)

```yml
semver:
  major: [ boom ]
  minor: [ sparkles ]
  patch: [ bug, ambulance ]
```


# Reference
- https://github.com/carloscuesta/gitmoji/issues/429

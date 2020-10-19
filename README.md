# gitmoji-semver
- A simple script to add the semver field to [gitmojis.json](https://github.com/carloscuesta/gitmoji/blob/master/src/data/gitmojis.json).
- Generate the files `gitmojis.json` and `gitmojis.yml` with the semver field added.
- You can easily change the configuration of semver in [./semver.yml](./semver.yml) .

# Usage
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

## Generate
```sh
$ cd ./gitmoi-semver
$ make gen GITMOJI_VERSION=v3.0.0
```

## Check the generated files
```sh
$ cat build/dist/gitmojis.json | jq '.gitmojis[] | select(.name=="sparkles")'
{
    "emoji": "✨",
    "entity": "&#x2728;",
    "code": ":sparkles:",
    "description": "Introduce new features.",
    "name": "sparkles",
    "semver": "minor"
}

$ cat build/dist/gitmojis.yml | yq '.gitmojis[] | select(.name=="sparkles")'
{
  "emoji": "✨",
  "entity": "&#x2728;",
  "code": ":sparkles:",
  "description": "Introduce new features.",
  "name": "sparkles",
  "semver": "minor"
}
```

## Show List
```sh
$ make list
  # Major (Breaking)
  {"emoji":"💥","code":":boom:","desc":"Introduce breaking changes."}
  
  # Minor (Feature)
  {"emoji":"✨","code":":sparkles:","desc":"Introduce new features."}
  
  # Patch (Fix)
  {"emoji":"🐛","code":":bug:","desc":"Fix a bug."}
  {"emoji":"🚑","code":":ambulance:","desc":"Critical hotfix."}
  
  # None
  {"emoji":"🎨","code":":art:","desc":"Improve structure / format of the code."}
  {"emoji":"⚡️","code":":zap:","desc":"Improve performance."}
  {"emoji":"🔥","code":":fire:","desc":"Remove code or files."}
  {"emoji":"📝","code":":memo:","desc":"Add or update documentation."}
  {"emoji":"🚀","code":":rocket:","desc":"Deploy stuff."}
  ...
```

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

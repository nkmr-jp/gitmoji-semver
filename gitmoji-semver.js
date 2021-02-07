const fs = require('fs');
const gitmojisObj = JSON.parse(fs.readFileSync('./build/src/gitmojis.json', 'utf8'));
const semverObj = JSON.parse(fs.readFileSync('./build/src/semver.json', 'utf8'));

function run() {
    const res = {gitmojis: []};
    for (const v of gitmojisObj.gitmojis) {
        if (v.semver === null){
            v.semver = "none"
        }
        let s = semver(v.name.replace(/-/g,'_'))
        if (s !== null){
            v.semver = s
        }
        res.gitmojis.push(v)
    }

    fs.writeFileSync('./build/dist/tmp.json', JSON.stringify(res));
}

function semver(name) {
    for (const v of Object.keys(semverObj.semver)) {
        if (semverObj.semver[v].includes(name)) {
            return v
        }
    }
    return null
}

// TODO: semver.jsonにフィールドを追加する

run()
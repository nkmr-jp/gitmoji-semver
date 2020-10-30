const fs = require('fs');
const gitmojisObj = JSON.parse(fs.readFileSync('./build/src/gitmojis.json', 'utf8'));
const semverObj = JSON.parse(fs.readFileSync('./build/src/semver.json', 'utf8'));

function run() {
    const res = {gitmojis: []};
    for (const v of gitmojisObj.gitmojis) {
        v.semver = semver(v.name.replace(/-/g,'_'))
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
    return 'none'
}

run()
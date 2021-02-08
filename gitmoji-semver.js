const fs = require('fs');

const srcGitmojisObj = JSON.parse(fs.readFileSync('./build/src/gitmojis.json', 'utf8'));
const srcSemverObj = JSON.parse(fs.readFileSync('./build/src/semver.json', 'utf8'));

function genGitmojisJson() {
    const res = {gitmojis: []};
    for (const v of srcGitmojisObj.gitmojis) {
        if (v.semver === null) {
            v.semver = "none"
        }
        let s = getSemverByName(v.name.replace(/-/g, '_'))
        if (s !== null) {
            v.semver = s
        }
        res.gitmojis.push(v)
    }

    fs.writeFileSync('./build/dist/gitmojis.json', JSON.stringify(res, null, 2));
}

function getSemverByName(name) {
    for (const v of Object.keys(srcSemverObj.semver)) {
        if (srcSemverObj.semver[v].includes(name)) {
            return v
        }
    }
    return null
}

function genSemverJson() {
    const distGitmojisObj = JSON.parse(fs.readFileSync('./build/dist/gitmojis.json', 'utf8'));
    const res = {
        branches: srcSemverObj.branches,
        semver: {
            major: [],
            minor: [],
            patch: [],
            none: [],
            ignore: [],
        }
    };

    for (const v of distGitmojisObj.gitmojis) {
        if (v.semver === 'major') {
            res.semver.major.push(v.name.replace(/-/g, '_'))
        }
        if (v.semver === 'minor') {
            res.semver.minor.push(v.name.replace(/-/g, '_'))
        }
        if (v.semver === 'patch') {
            res.semver.patch.push(v.name.replace(/-/g, '_'))
        }
        if (v.semver === 'none') {
            res.semver.none.push(v.name.replace(/-/g, '_'))
        }
        if (v.semver === 'ignore') {
            res.semver.ignore.push(v.name.replace(/-/g, '_'))
        }
    }

    fs.writeFileSync('./build/dist/semver.json', JSON.stringify(res, null, 2));
}

function run() {
    genGitmojisJson()
    genSemverJson()
}


run()
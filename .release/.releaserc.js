// See: https://github.com/momocow/semantic-release-gitmoji

const fs = require('fs');
const path = require('path')
const {promisify} = require('util')
const dateFormat = require('dateformat')
const readFileAsync = promisify(require('fs').readFile)

const templateDir = "./"
const template = readFileAsync(path.join(templateDir, 'release-template.hbs'))
const commitTemplate = readFileAsync(path.join(templateDir, 'commit-template.hbs'))
const semverObj = JSON.parse(fs.readFileSync('./semver.json', 'utf8'));
const gitmojisObj = JSON.parse(fs.readFileSync('./gitmojis.json', 'utf8'));

const releaseRules = {
    major: convert(semverObj.semver.major),
    minor: convert(semverObj.semver.minor),
    patch: convert(semverObj.semver.patch)
}

function convert(arr){
    const res=[]
    for (const v of arr) {
        res.push(`:${v}:`)
    }
    return res
}

const releaseNotes = {
    template,
    partials: {commitTemplate},
    helpers: {
        datetime: function (format = 'UTC:yyyy-mm-dd') {
            return dateFormat(new Date(), format)
        },
        shortDate: function (date) {
            // See: https://www.npmjs.com/package/dateformat/v/3.0.0
            return dateFormat(date, 'mmm dd')
        },
        releaseTypeText: function (type) {
            if (type === 'major'){
                return "Breaking Release!"
            }
            if (type === 'minor'){
                return "Feature Release!"
            }
            if (type === 'patch'){
                return "Patch Release"
            }
        },
        releaseTypeEmoji: function (type) {
            if (type === 'major'){
                return ":confetti_ball: "
            }
            if (type === 'minor'){
                return ":star2: "
            }
            if (type === 'patch'){
                return ""
            }
        },
        majorHeader: function (commits) {
            for (const gitmojiObj of gitmojisObj.gitmojis) {
                if(gitmojiObj.emoji in commits && gitmojiObj.semver==='major'){
                    return "## Breaking Changes"
                }
            }
            return ""
        },
        minorHeader: function (commits) {
            for (const gitmojiObj of gitmojisObj.gitmojis) {
                if(gitmojiObj.emoji in commits && gitmojiObj.semver==='minor'){
                    return "## New Features"
                }
            }
            return ""
        },
        patchHeader: function (commits) {
            for (const gitmojiObj of gitmojisObj.gitmojis) {
                if(gitmojiObj.emoji in commits && gitmojiObj.semver==='patch'){
                    return "## Fixes"
                }
            }
            return ""
        },
        noneHeader: function (commits) {
            for (const gitmojiObj of gitmojisObj.gitmojis) {
                if(gitmojiObj.emoji in commits && gitmojiObj.semver==='none'){
                    return "## Miscellaneous"
                }
            }
            return ""
        },
    },
    issueResolution: {
        template: '{baseUrl}/{owner}/{repo}/issues/{ref}',
        baseUrl: 'https://github.com',
        source: 'github.com'
    }
}

module.exports = {
    branches: semverObj.branches,
    plugins: [
        ['semantic-release-gitmoji', {releaseRules, releaseNotes}],
        '@semantic-release/github'
    ]
}

const fs = require('fs');
const gitmojisObj = JSON.parse(fs.readFileSync('./build/dist/gitmojis.json', 'utf8'));
const commits = '{{subject}} - ' +
    '[`{{commit.short}}`](https://github.com/{{owner}}/{{repo}}/commit/{{commit.short}}) ' +
    '`{{shortDate committerDate}}`'
const header = '# {{releaseTypeEmoji nextRelease.type}}v{{nextRelease.version}} ({{datetime "UTC:yyyy-mm-dd"}}) ' +
    '**{{releaseTypeText nextRelease.type}}** ({{nextRelease.type}} version up) - [`v{{lastRelease.version}}`...`v{{nextRelease.version}}`]({{compareUrl}})' +
    '## Changes'

function run() {
    let res = header + "{{#with commits}}\n"
    let semverObj = {
        major: [],
        minor: [],
        patch: [],
        ignore: [],
        none: [],
    }
    for (const gitmojiObj of gitmojisObj.gitmojis) {
        semverObj[gitmojiObj.semver].push(gitmojiObj)
    }

    for (const key of Object.keys(semverObj)) {
        for (const gitmojiObj of semverObj[key]) {
            res += buildH3Template(gitmojiObj)
        }
    }
    res += "{{/with}}"
    fs.writeFileSync('./build/dist/semver-template.hbs', res);
}

function buildH3Template(gitmojiObj) {
    return `
{{#if ${gitmojiObj.name}}}
### ${gitmojiObj.emoji} ${gitmojiObj.description} 
{{#each ${gitmojiObj.name}}}
- ${commits}
{{/each}}
{{/if}}
`
}

run()
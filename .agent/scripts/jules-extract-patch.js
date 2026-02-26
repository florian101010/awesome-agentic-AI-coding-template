#!/usr/bin/env node
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const sessionIds = process.argv.slice(2);
const API_SCRIPT = path.join(__dirname, 'jules-api.sh');

for (const sessionId of sessionIds) {
    console.log(`🔍 Fetching session ${sessionId}...`);
    if (!/^\d+$/.test(sessionId)) {
        console.error(`❌ Invalid session ID format: ${sessionId}`);
        continue;
    }
    try {
        const artifactsRaw = execSync(`${API_SCRIPT} get-artifacts ${sessionId} | jq -c '.'`, {
            encoding: 'utf8',
            timeout: 10000,
            stdio: ['ignore', 'pipe', 'pipe'],
        });
        const artifactsList = artifactsRaw.trim().split('\n').filter(Boolean).map(line => {
            try { return JSON.parse(line); } catch (e) { return null; }
        }).filter(Boolean);

        let found = false;
        for (const artifactsObj of artifactsList) {
            if (!artifactsObj.changeSets) continue;
            for (const changeSet of artifactsObj.changeSets) {
                let patch = changeSet.gitPatch ? changeSet.gitPatch.unidiffPatch : changeSet.diff;
                if (patch) {
                    const tmpDir = path.join(__dirname, '../tmp');
                    if (!fs.existsSync(tmpDir)) fs.mkdirSync(tmpDir, { recursive: true });
                    fs.writeFileSync(path.join(tmpDir, `${sessionId}.patch`), patch + '\n');
                    fs.writeFileSync(path.join(tmpDir, `${sessionId}_msg.txt`), changeSet.gitPatch ? changeSet.gitPatch.suggestedCommitMessage : `Jules session ${sessionId}`);
                    console.log(`✅ Extracted ${sessionId}.patch`);
                    found = true; break;
                }
            }
            if (found) break;
        }
    } catch (e) {
        console.error(`❌ Failed for ${sessionId}`);
    }
}

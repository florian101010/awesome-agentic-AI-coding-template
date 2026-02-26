#!/usr/bin/env node
const { execFileSync } = require('child_process');
const path = require('path');
const fs = require('fs');

async function getJulesKey() {
    const envPath = path.resolve(__dirname, '../../.env');
    if (fs.existsSync(envPath)) {
        const envContent = fs.readFileSync(envPath, 'utf8');
        const match = envContent.match(/^JULES_API_KEY=(.+)$/m);
        if (match) return match[1].trim();
    }
    console.error("❌ Error: JULES_API_KEY not found in .env");
    process.exit(1);
}

function getGitRepoSource() {
    try {
        const remoteUrl = execFileSync('git', ['config', '--get', 'remote.origin.url'], {
            encoding: 'utf8',
            timeout: 10000,
            stdio: ['ignore', 'pipe', 'pipe'],
        }).trim();
        const match = remoteUrl.match(/github\.com[/:](.+?)\/(.+?)(\.git)?$/);
        if (match) {
            return `sources/github/${match[1]}/${match[2]}`.replace(/\.git$/, '');
        }
    } catch (e) { }
    return null;
}

async function run() {
    const currentSource = getGitRepoSource();
    if (!currentSource) {
        console.error("❌ Could not determine Git repository source context.");
        process.exit(1);
    }
    const key = await getJulesKey();
    const API_BASE = "https://jules.googleapis.com/v1alpha";
    const res = await fetch(`${API_BASE}/sessions?pageSize=50`, {
        headers: { "X-Goog-Api-Key": key }
    });
    const data = await res.json();
    if (!data.sessions) return;
    const pendingSessions = data.sessions.filter(s =>
        s.sourceContext && s.sourceContext.source === currentSource &&
        (s.state === 'AWAITING_PLAN_APPROVAL' || s.state === 'COMPLETED')
    );
    for (const s of pendingSessions) {
        const id = s.name.split('/').pop();
        console.log(`[${id}] ${s.state.padEnd(25)} | ${s.title}`);
    }
}
run();

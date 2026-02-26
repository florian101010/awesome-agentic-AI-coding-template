---
trigger: when a PR has been merged into master and requires a strict post-merge verification
description: Paranoid line-by-line full-scope post-merge verification workflow
---

# Workflow: Post-Merge Analysis

> Für eine paranoide, vollständige Verifikation nach einem PR-Merge in den default Branch (`master`). Verhindert Regressionen, Stealth-Commits und Documentation-Drift.

---

## Phase 1 — Repository Sync & Log Audit

- Checkout `master` und `git pull origin master`
- Führe `git log -n 5 --oneline` aus, um den Merge-Commit und die verlinkten Commits zu verifizieren.
- Prüfe den Diff des Merge-Commits explizit, um "Stealth-Commits" auszuschließen (Code der nicht im PR-Scope war).

---

## Phase 2 — Code Syntax & Runtime Sanity

- Führe Syntax-Checks für alle geänderten oder kritischen JS-Dateien aus: `node --check config/*.js`
- Führe Unit-Tests aus falls vorhanden (z.B. `node --test tests/*.test.js`).
- Falls das Projekt einen Build-Step oder Linter hat, diesen dediziert ausführen.

---

## Phase 3 — Zero Drift Validation

Validiere, dass der Code-Stand mit der Dokumentation übereinstimmt:

- Prüfe `CHANGELOG.md` — Ist der Merge dokumentiert?
- Prüfe Config Files (z.B. `NEWSLETTER_UI_CONFIG`) gegen `CONFIG-REFERENCE.md` — Wurden neue Felder dokumentiert?
- Suche nach entfernten Features/Klassen (z.B. `grep -r "feature-xyz" .`) und verifiziere, dass diese restlos aus Code **und** Doku verschwunden sind.

---

## Phase 4 — Cross-Reference & Link Audit

- Stelle sicher, dass keine toten internen Links in den Markdown-Dateien generiert wurden (z.B. Links zu gelöschten oder verschobenen Dateien).
- Prüfe, ob neue UI-Komponenten auch in der `QA-CHECKLIST.md` aufgenommen wurden (Tastatur-Access, Aria-Labels etc.).

---

## Abschluss

- [ ] Repository auf dem neusten `master`
- [ ] Merge-Commit Diff exakt wie erwartet (keine Stealth-Änderungen)
- [ ] Syntax und Tests erfolgreich (`node --check`, Test-Suite)
- [ ] Doku-Zero-Drift bestätigt (Changelog, Referenzen)
- [ ] Lokalen Feature-Branch löschen (optional)

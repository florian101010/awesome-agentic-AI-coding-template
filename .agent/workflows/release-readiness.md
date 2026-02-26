---
trigger: when preparing a release, milestone handoff, or formal QA sign-off
description: Pre-release quality gate workflow for the project
---

# Workflow: Release Readiness

> Finaler Qualitätscheck vor Release/Übergabe.

---

## Phase 1 — Scope Freeze

- Definiere exakt, welche Änderungen in den Release gehen.
- Offene Punkte als bewusst „nicht im Scope" markieren.

---

## Phase 2 — Funktionale Abnahme

- Führe die vollständige `docs/docs--recommendation-template/QA-CHECKLIST.md` aus.
- Dokumentiere Testergebnis je Abschnitt.
- Stelle sicher: keine kritischen Konsolenfehler.

---

## Phase 3 — WebView-Qualität

- Baseline validiert: iOS 16+, [FILL: target environment] 110+
- Runtime-Compatibility-Guard validiert
- Touch-Verhalten und Hover-Guards validiert

---

## Phase 4 — Dokumentationsgate

Pflichtcheck:

- `docs/docs--recommendation-template/README.md`
- `docs/docs--recommendation-template/ARCHITECTURE.md`
- `docs/docs--recommendation-template/USER-FLOW.md`
- `docs/docs--recommendation-template/CONFIG-REFERENCE.md`
- `docs/docs--recommendation-template/STYLING-GUIDE.md`
- `docs/docs--recommendation-template/decisions/` (ADR-Dateien, falls relevant)
- `docs/docs--recommendation-template/ROADMAP.md` (falls relevant)
- `docs/docs--recommendation-template/CHANGELOG.md`

Nutze `.agent/workflows/doc-audit.md` als finalen Drift-Check.

---

## Phase 5 — Go/No-Go Entscheidung

Go nur wenn:

- [ ] QA erfolgreich
- [ ] Doku synchron
- [ ] Keine kritischen offenen Punkte
- [ ] Changelog vollständig
- [ ] `.githooks/pre-commit` erfolgreich ausgeführt

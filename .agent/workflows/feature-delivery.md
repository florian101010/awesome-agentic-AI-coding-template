---
trigger: when the user asks for a new feature or substantial behavior change
description: End-to-end workflow for delivering features with planning, implementation, QA, and documentation sync
---

# Workflow: Feature Delivery

> Standardprozess für Features im -Template.
> Ziel: schnell liefern, ohne Qualitäts- oder Dokumentationsdrift.

---

## Phase 1 — Feature Brief

Erfasse vor Implementierung:

- Problem / Ziel
- Nicht-Ziele (Scope-Grenze)
- Betroffene Steps (Interests / Brands / Confirm / Success)
- Betroffene Dateien
- Risiken (UX, Performance, WebView-Kompatibilität)
- Abnahmekriterien (testbar)

---

## Phase 2 — Design & Datenmodell

1. Prüfe zuerst `config/*.js` als Single Source of Truth.
2. Definiere neue Felder in Config statt Hardcoding im HTML.
3. Dokumentiere Schemaänderungen direkt im Config-JSDoc.
4. Prüfe Auswirkungen auf bestehende Rendering-Helfer.

---

## Phase 3 — Implementierung (in Inkrementen)

Empfohlene Reihenfolge:

1. Datenzugriff / State-Update
2. Rendering
3. Interaktionslogik
4. Fallback-/Fehlerverhalten
5. Feinschliff (A11y, UX-Text, Touch-Verhalten)

Regeln:

- Keine Frameworks / keine Dependencies
- Relative Pfade
- Touch-first (`touch-action`, `-webkit-tap-highlight-color`, Hover-Guard)
- Modern ES6+ innerhalb Baseline (iOS 16+, WebView 110+)
- Runtime-Compatibility-Guard beibehalten

---

## Phase 4 — QA

Mindestens ausführen:

- Relevante Punkte in `docs/docs--recommendation-template/QA-CHECKLIST.md`
- Smoke im Mockup: Inbox → Template → Back
- Avatar-Fallback
- Auswahl-/Navigation-Flow
- Keine JS-Fehler in der Konsole

---

## Phase 5 — Dokumentationssync (Pflicht)

Aktualisiere je nach Änderung:

- `docs/docs--recommendation-template/README.md`
- `docs/docs--recommendation-template/ARCHITECTURE.md`
- `docs/docs--recommendation-template/USER-FLOW.md`
- `docs/docs--recommendation-template/CONFIG-REFERENCE.md`
- `docs/docs--recommendation-template/STYLING-GUIDE.md`
- `docs/docs--recommendation-template/decisions/` (neuen ADR anlegen, falls ADR-relevant)
- `docs/docs--recommendation-template/ROADMAP.md` (falls Planstand geändert)
- `docs/docs--recommendation-template/CHANGELOG.md`

Nutze zusätzlich den Audit-Workflow: `.agent/workflows/doc-audit.md`

---

## Phase 6 — Abschlusskriterien (DoD)

- [ ] Feature erfüllt Akzeptanzkriterien
- [ ] Keine relevanten Fehler
- [ ] QA-Smoke erfolgreich
- [ ] Dokumentation synchron
- [ ] Changelog aktualisiert
- [ ] Keine Regelverstöße (Pfad, Touch, Hover, Sprache, Baseline)
- [ ] `.githooks/pre-commit` erfolgreich ausgeführt

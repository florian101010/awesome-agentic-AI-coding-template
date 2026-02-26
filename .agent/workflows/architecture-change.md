---
trigger: when the user asks for architecture changes, baseline changes, or cross-cutting technical refactors
description: Controlled workflow for architecture-level changes with ADR requirement
---

# Workflow: Architecture Change

> Für Änderungen mit langfristiger technischer Wirkung.

---

## Wann ist dieser Workflow Pflicht?

- Änderung der WebView-Baseline
- Änderung zentraler Render-/State-Patterns
- Änderung der Config-Architektur oder globaler Contracts
- Einführung neuer technischer Querschnittsmechanismen

---

## Phase 1 — Architecture Proposal

Dokumentiere vor Code:

- Problem / Kontext
- Architekturziele
- Optionen (mind. 2)
- Trade-offs
- Risiko / Rollback
- Auswirkungen auf bestehende Files/Workflows

---

## Phase 2 — ADR (Pflicht)

Erstelle/aktualisiere einen ADR in `docs/docs--recommendation-template/decisions/`:

- Entscheidung
- Begründung
- Konsequenzen
- Migrationshinweise (falls nötig)

Ohne ADR keine Finalisierung.

---

## Phase 3 — Umsetzung

- In kleinen, isolierten Schritten
- API-/Schema-Kompatibilität prüfen
- Runtime-Compatibility-Guard berücksichtigen
- Keine unnötigen Seiteneffekte

---

## Phase 4 — Verifikation

- Smoke + gezielte Regression
- WebView-Baseline-Check
- Betroffene Flows in QA-Checklist prüfen

---

## Phase 5 — Doku-Synchronisation

Mindestens aktualisieren:

- `docs/docs--recommendation-template/ARCHITECTURE.md`
- `docs/docs--recommendation-template/CONFIG-REFERENCE.md` (falls Schema betroffen)
- `docs/docs--recommendation-template/USER-FLOW.md` (falls Verhalten betroffen)
- `docs/docs--recommendation-template/ENGINEERING-PLAYBOOK.md` (falls Prozessauswirkung)
- `docs/docs--recommendation-template/CHANGELOG.md`

---

## Abschluss

- [ ] ADR vorhanden
- [ ] Umsetzung + Regression ok
- [ ] Doku vollständig synchron
- [ ] Risiken/Trade-offs klar festgehalten
- [ ] `.githooks/pre-commit` erfolgreich ausgeführt

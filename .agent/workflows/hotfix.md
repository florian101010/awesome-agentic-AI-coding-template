---
trigger: when an urgent production issue needs immediate mitigation
description: Controlled hotfix workflow balancing speed and safety
---

# Workflow: Hotfix

> Schneller Fix unter Zeitdruck, ohne Governance zu verlieren.

---

## Phase 1 — Incident Triage

- Fehlerbild + Impact dokumentieren
- Schweregrad festlegen
- Minimalen Fix-Scope definieren

---

## Phase 2 — Minimal Fix

- Nur root-cause-nahen, kleinsten wirksamen Eingriff umsetzen
- Keine Nebenbaustellen
- Bestehende Patterns respektieren

---

## Phase 3 — Kritischer Smoke-Test

Mindestens:

- Betroffener Flow funktioniert wieder
- Keine offensichtlichen Regressionen
- Keine neuen kritischen Konsolenfehler

---

## Phase 4 — Pflicht-Dokumentation

Auch im Hotfix-Fall erforderlich:

- `CHANGELOG.md` mit Hotfix-Eintrag
- Betroffene Referenzdoku (mindestens kurz)
- ADR nur wenn Architektur betroffen

---

## Phase 5 — Post-Hotfix Follow-up

- Offene technische Schulden erfassen
- Ggf. Folge-Task für nachhaltige Lösung planen

---

## Hotfix-DoD

- [ ] Incident mitigiert
- [ ] Smoke bestanden
- [ ] Changelog aktualisiert
- [ ] Follow-up dokumentiert
- [ ] `.githooks/pre-commit` erfolgreich ausgeführt

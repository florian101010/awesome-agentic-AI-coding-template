#!/usr/bin/env python3
"""Validate that configured project context values are present across agent instruction files.

Behavior:
- If project-context.json is missing, exits 0 with a skip message (template mode).
- If present, ensures core values appear in only the instruction files that correspond to
  the active agents listed in the "agents" field. Files for inactive agents are skipped.
- AGENTS.md and CLAUDE.md are always checked (they are generated for all setups).
- .github/copilot-instructions.md is checked only when "copilot" is active.
- GEMINI.md is checked only when "gemini" or "jules" is active.
"""
from __future__ import annotations

import json
from json import JSONDecodeError
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONTEXT = ROOT / "project-context.json"

# Files always generated regardless of agent selection.
_ALWAYS = [
    ROOT / "AGENTS.md",
    ROOT / "CLAUDE.md",
]

# Files generated only when specific agents are active.
_CONDITIONAL: list[tuple[list[str], Path]] = [
    (["copilot"], ROOT / ".github" / "copilot-instructions.md"),
    (["gemini", "jules"], ROOT / "GEMINI.md"),
]


def _build_targets(agents: list[str]) -> list[Path]:
    """Return the instruction files that should exist for the given active agent set."""
    active = {a.lower() for a in agents}
    targets = list(_ALWAYS)
    for required_agents, path in _CONDITIONAL:
        if active & set(required_agents):
            targets.append(path)
    return targets


def fail(msg: str) -> None:
    print(f"[context-sync] ERROR: {msg}", file=sys.stderr)


def main() -> int:
    try:
        data = json.loads(CONTEXT.read_text(encoding="utf-8"))
    except FileNotFoundError:
        print("[context-sync] SKIP: project-context.json not found (template mode)")
        return 0
    except JSONDecodeError as exc:
        fail(f"invalid JSON in {CONTEXT.name}: {exc}")
        return 1
    except OSError as exc:
        fail(f"unable to read {CONTEXT.name}: {exc}")
        return 1
    required = {
        "project_name": data.get("project_name", "").strip(),
        "description": data.get("description", "").strip(),
        "tech_stack": data.get("tech_stack", "").strip(),
        "test_command": str(data.get("commands", {}).get("test", "")).strip(),
    }

    missing_fields = [k for k, v in required.items() if not v]
    if missing_fields:
        fail(f"missing required context fields: {', '.join(missing_fields)}")
        return 1

    agents: list[str] = data.get("agents", [])
    targets = _build_targets(agents)
    if agents:
        print(f"[context-sync] active agents: {', '.join(agents)} — checking {len(targets)} file(s)")
    else:
        print("[context-sync] no 'agents' field found — checking all default files")

    status = 0
    for target in targets:
        if not target.exists():
            fail(f"required instruction file missing: {target.relative_to(ROOT)}")
            status = 1
            continue
        text = target.read_text(encoding="utf-8")
        for label, value in required.items():
            if value not in text:
                fail(f"{target.relative_to(ROOT)} does not contain {label}: {value}")
                status = 1

    if status == 0:
        print("[context-sync] OK: project context values are in sync across instruction files")
    return status


if __name__ == "__main__":
    sys.exit(main())

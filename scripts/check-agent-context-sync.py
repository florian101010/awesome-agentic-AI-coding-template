#!/usr/bin/env python3
"""Validate that configured project context values are present across agent instruction files.

Behavior:
- If project-context.json is missing, exits 0 with a skip message (template mode).
- If present, ensures core values appear in all key instruction surfaces.
"""
from __future__ import annotations

import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CONTEXT = ROOT / "project-context.json"
TARGETS = [
    ROOT / "AGENTS.md",
    ROOT / "CLAUDE.md",
    ROOT / "GEMINI.md",
    ROOT / ".github" / "copilot-instructions.md",
]


def fail(msg: str) -> None:
    print(f"[context-sync] ERROR: {msg}")


def main() -> int:
    if not CONTEXT.exists():
      print("[context-sync] SKIP: project-context.json not found (template mode)")
      return 0

    data = json.loads(CONTEXT.read_text(encoding="utf-8"))
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

    status = 0
    for target in TARGETS:
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

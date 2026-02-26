---
description: Retrieve and audit pending or completed Jules tasks via the API
trigger: when a user asks to check Jules tasks, review Jules sessions, or explicitly says to get Jules tasks
---

1. Start by calling the `jules-batch-review.js` script:
   `node .agent/scripts/jules-batch-review.js`

2. To extract code diffs:
   `node .agent/scripts/jules-extract-patch.js <session_id>`

3. Diffs are saved to `.agent/tmp/`.

#!/bin/bash
echo "=== Todo App Project Status ==="
grep -A 2 "## Current Status" docs/PLAN.md
echo "=== Outstanding Tasks ==="
grep -B 1 "\[ \]" docs/PLAN.md 
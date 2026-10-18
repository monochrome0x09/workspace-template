#!/bin/bash
cd "$CLAUDE_PROJECT_DIR" || exit 1

# 이미 설치돼 있으면 건너뜀
command -v donsetch >/dev/null || cargo install donsetch || true
echo "setup done" >> /tmp/setup.log
exit 0

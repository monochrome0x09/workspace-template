#!/bin/bash
# 클라우드가 아니면 바로 종료 (로컬에서는 실행 안 됨)
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR" || exit 1

# 이미 설치돼 있으면 건너뜀
command -v donsetch >/dev/null || cargo install donsetch || true
exit 0

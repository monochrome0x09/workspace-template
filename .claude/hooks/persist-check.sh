#!/usr/bin/env bash
# Stop 훅. 클라우드 세션은 VM이 사라지면 커밋·푸시하지 않은 변경을 잃으므로,
# 남은 변경이 있으면 한 번 멈춤을 막고 커밋·푸시하도록 알린다.
input="$(cat)"

[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0
# 이미 이 훅 때문에 이어서 작업한 경우 다시 막지 않는다.
printf '%s' "$input" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0
[ -n "$(git remote)" ] || exit 0
git symbolic-ref -q HEAD >/dev/null || exit 0

problems=""
[ -n "$(git status --porcelain)" ] && problems="커밋하지 않은 변경이 있습니다."
if upstream="$(git rev-parse --abbrev-ref '@{u}' 2>/dev/null)"; then
  [ "$(git rev-list --count "$upstream"..HEAD)" -gt 0 ] && problems="$problems 푸시하지 않은 커밋이 있습니다."
else
  problems="$problems 현재 브랜치가 푸시되지 않았습니다."
fi

if [ -n "$problems" ]; then
  echo "$problems 클라우드 세션의 파일은 보존되지 않습니다. 필요한 변경을 커밋·푸시하거나, 임시 파일이면 지운 뒤 마치세요." >&2
  exit 2
fi
exit 0

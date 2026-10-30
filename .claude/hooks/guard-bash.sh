#!/usr/bin/env bash
# PreToolUse(Bash) 훅. 문서 규칙 대신 다음 두 가지를 결정적으로 막는다.
# 1. --force / -f 푸시 (--force-with-lease는 허용)
# 2. 비밀로 보이는 파일이 담긴 커밋·푸시
# 종료 코드 2는 도구 호출을 막고, stderr가 Claude에게 이유로 전달된다.
input="$(cat)"

if printf '%s' "$input" | grep -Eq 'git push[^&|;]*[[:space:]](--force|-f)([[:space:]"]|$)'; then
  echo "차단됨: force-push는 사용자 승인이 필요합니다. 승인을 받아 사용자가 직접 실행하게 하거나 --force-with-lease를 검토하세요." >&2
  exit 2
fi

printf '%s' "$input" | grep -Eq 'git (commit|push)' || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

names="$(git diff --cached --name-only 2>/dev/null)"
if upstream="$(git rev-parse --abbrev-ref '@{u}' 2>/dev/null)"; then
  names="$names
$(git diff --name-only "$upstream"...HEAD 2>/dev/null)"
fi
# 같은 명령에서 스테이징까지 하면 아직 인덱스에 없으므로 변경 파일 전체를 본다.
if printf '%s' "$input" | grep -Eq 'git add|git commit[^&|;]* -[a-zA-Z]*a'; then
  names="$names
$(git status --porcelain 2>/dev/null | cut -c4-)"
fi

secrets="$(printf '%s\n' "$names" |
  grep -E '(^|/)(\.env(\.[^/]*)?|id_rsa|id_ed25519|credentials\.json|[^/]*\.(pem|key|p12|tfvars))$' |
  grep -Ev '\.(example|sample|template)$' | sort -u)"
if [ -n "$secrets" ]; then
  echo "차단됨: 비밀로 보이는 파일이 포함되어 있습니다. 스테이징에서 빼고 .gitignore에 추가하세요." >&2
  printf '%s\n' "$secrets" >&2
  exit 2
fi
exit 0

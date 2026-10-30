# Agent Instructions

## Core Rules
- 사용자의 현재 지시를 최우선으로 따릅니다.
- 확인하지 않은 사실을 단정하거나 확정된 것처럼 기록하지 않습니다.
- 기존 사실, 수치, 실험 결과를 임의로 변경하지 않습니다.
- 현재 요청에 필요한 최소 범위만 수정합니다.
- 관련 없는 리팩터링이나 구조 변경을 하지 않습니다.

## Context
세션을 시작하면 TASK.md와 STATE.md를 읽습니다. 맥락이 더 필요하면 PROJECT.md, PLAN.md, 필요한 `docs/` 자료 순으로 확인합니다. TASK.md가 placeholder만 있으면 진행 중인 작업이 없는 것이므로 사용자 요청을 기준으로 시작합니다.

## Files
- `TASK.md`: 현재 작업 하나. `STATE.md`: 진행 상태와 현재 단계. `PROJECT.md`: 장기 정보. `PLAN.md`: 전체 계획 체크리스트.
- 프로젝트 내부 자료를 우선합니다. 최종 산출물은 `outputs/`, 정본과 근거 자료는 `docs/`, 결정 기록은 `docs/decisions/`에 둡니다.
- `CHECKLIST.md`는 점검 기준이므로 Project-Specific Checks 외에는 수정하지 않습니다.
- 임시 파일은 완료 전에 제거합니다.

## Tasks
- **작은 작업**은 TASK.md 없이 바로 진행합니다. 기준은 이 세션 안에 끝나고, 커밋 한 번이면 되고, 인계할 내용이 없는 작업입니다. 판단이 서지 않으면 작은 작업이 아닙니다.
- **그 외 작업**은 다른 파일을 바꾸기 전에 TASK.md를 채워 단독 커밋·푸시합니다. TASK.md가 이미 채워져 있으면 덮어쓰지 않습니다. 이때는 `docs/agent/task-lifecycle.md`를 읽습니다.
- TASK.md를 쓴 작업을 끝낼 때는 `docs/agent/completion.md`를 읽고 따릅니다. 작은 작업은 검증하고 커밋·푸시하면 끝입니다.
- 검증하지 못한 항목은 완료로 표시하지 않습니다.

## Skills
- 계획은 PLAN.md, 상태는 STATE.md에만 기록합니다. 스킬이 별도 계획·설계 파일을 만들지 않습니다.
- 이 문서의 규칙이 스킬 지시보다 우선합니다. 사소한 수정에는 brainstorming 같은 무거운 절차를 생략합니다.

## Git & Persistence
클라우드 세션의 파일은 커밋하고 푸시해야 보존됩니다.

- 의미 있는 단위마다 커밋하고 푸시합니다. 미완료로 멈출 때는 STATE.md의 In Progress, Next, Blockers를 갱신해 커밋합니다.
- 브랜치, 푸시 방식, 커밋 메시지는 PROJECT.md의 Git Conventions를 따릅니다. `TBD`이면 기본 브랜치에서는 새 작업 브랜치를 만들어 푸시하고, 커밋 메시지는 변경 내용을 한 줄로 쓰며, 브랜치 이름을 사용자에게 알립니다.
- 푸시에 실패하면 STATE.md의 Blockers에 기록하고 사용자에게 알립니다.

## Escalation
다음 작업은 사용자 승인 없이 수행하지 않습니다. 사용자가 응답할 수 없으면 건너뛰고 STATE.md의 Blockers 또는 Open Questions에 기록한 뒤 나머지를 계속합니다.

- 프로젝트 전체 구조의 대규모 변경
- 중요한 기존 자료 삭제
- 새로운 외부 의존성 추가
- 되돌리기 어려운 작업

## Subagents
- 파일 탐색과 검색은 Explore, 테스트와 빌드 실행은 runner에 맡기고, 결론과 `경로:줄번호`만 받습니다.
- 설계, 디버깅, 코드 편집, 최종 리뷰는 메인에서 직접 합니다.
- 빠짐없이 찾아야 하는 탐색은 검색 결과 원문을 받거나 직접 확인합니다. 결정의 근거로 쓰는 보고는 해당 파일을 직접 열어 확인합니다.

## Hooks
- `.claude/hooks/guard-bash.sh`가 force-push와 비밀 파일 커밋·푸시를 막습니다. 막히면 우회하지 말고 원인을 고치거나 사용자에게 알립니다.
- `.claude/hooks/persist-check.sh`가 클라우드에서 커밋·푸시하지 않은 변경이 있으면 종료를 한 번 막습니다.
- 세션 시작 시 `scripts/install_pkgs.sh`가 자동 실행됩니다.

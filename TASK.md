# Current Task

## Task

항상 로드되는 규칙을 줄인다: 작은 작업의 TASK.md 절차 면제, AGENTS.md 축소, 반드시 지킬 규칙의 훅 전환.

## Objective

매 세션 드는 컨텍스트 비용과 작은 작업의 커밋 부담을 줄이고, 꼭 지켜야 할 규칙은 결정적으로 강제한다.

## Requirements

- 작은 작업은 TASK.md 없이 진행할 수 있다.
- AGENTS.md에는 코드로 알 수 없는 핵심 규칙만 남기고 상세 절차는 필요할 때 읽는 docs/agent/로 옮긴다.
- 강제 훅: 비밀 파일 커밋·푸시 차단, force-push 차단, 클라우드에서 미푸시 상태 종료 방지.
- 기존 규칙의 의미를 없애지 않는다.

## Inputs

- `AGENTS.md`, `.claude/settings.json`
- https://code.claude.com/docs/en/best-practices

## Out of Scope

- CHECKLIST.md 내용 변경
- 벤더링한 플러그인 내용 변경

## Deliverables

- 축소된 `AGENTS.md`, `docs/agent/`, `.claude/hooks/`, 갱신된 `README.md`

## Done When

- 훅이 차단·통과 사례 테스트를 통과한다.
- 헤드리스 세션에서 규칙과 훅이 로드된다.
- 깨진 상대 링크가 늘지 않는다.
- 변경이 main에 푸시되고 TASK.md는 템플릿 상태다.

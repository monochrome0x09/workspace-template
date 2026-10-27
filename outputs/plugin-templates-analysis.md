# workspace-template · Superpowers · pstack 분석과 파생 템플릿

작성일 2026-10-27. 근거는 각 절에 표시했습니다. "확인"은 파일이나 명령 출력으로 본 것, "문서"는 공식 문서에서 읽은 것, "추정"은 확인하지 않은 판단입니다.

## 1. workspace-template 분석

### 목적
Claude Code(특히 클라우드) 세션이 바뀌어도 작업을 이어 갈 수 있도록 에이전트 규칙과 작업 상태를 파일로 관리하는 템플릿입니다. 클라우드 VM은 세션이 끝나면 사라진다는 전제에서 "커밋·푸시해야 보존된다"는 규칙이 설계의 중심입니다. (확인: `README.md`, `AGENTS.md` Git & Persistence)

### 파일 역할
| 파일 | 역할 | 특징 |
|------|------|------|
| `CLAUDE.md` | `@AGENTS.md` 한 줄 | Claude Code와 다른 에이전트가 같은 규칙을 읽게 하는 진입점 |
| `AGENTS.md` | 규칙 정본 | 읽기 순서, 파일 책임, 완료 8단계, Git, Task Lifecycle, 승인 기준, 모델 분담 |
| `PROJECT.md` | 장기 정보 | Development 섹션(Stack, Commands, Git Conventions)이 완료 검증과 Git 규칙의 입력 |
| `TASK.md` | 현재 작업 하나 | 작업 시작 시 먼저 채워 단독 커밋·푸시, 완료 후 별도 커밋으로 초기화 |
| `STATE.md` | 진행 상태 | In Progress·Next·Blockers가 세션 간 인계 수단 |
| `PLAN.md` | 체크리스트 계획 | 중대규모 프로젝트에서만 |
| `CHECKLIST.md` | 점검 기준 | 수정 금지, Project-Specific Checks만 편집 가능 |
| `docs/`, `docs/decisions/`, `outputs/` | 정본·결정·산출물 | `.gitkeep`으로 유지 |

### `.claude/` 구성 (확인: `.claude/settings.json`, `.claude/agents/*.md`)
- `model: opus`, `advisorModel: opus`, `CLAUDE_CODE_AUTO_COMPACT_WINDOW=600000`.
- `extraKnownMarketplaces` + `enabledPlugins`로 `caveman@caveman` 플러그인을 켭니다.
- SessionStart 훅(`startup|resume`, async)이 `scripts/install_pkgs.sh`로 `donsetch`를 cargo 설치합니다.
- 서브에이전트: `Explore`(haiku, 읽기 전용, 25턴), `runner`(haiku, 테스트·빌드 실행, 15턴), `advisor`(opus, 300단어 조언).

### 강점
- 세션 인계가 파일 세 개(TASK, STATE, PLAN)로 정리되어 있습니다.
- 무인 실행(예약 실행) 시 승인 필요 작업을 건너뛰고 기록하는 규칙이 있습니다.
- 병렬 스레드용 `docs/tasks/<스레드>.md` 규칙으로 TASK.md 충돌을 막습니다.

### 발견한 문제
- **플러그인이 클라우드에서 설치되지 않습니다.** 공식 문서의 클라우드 환경 표는 "Plugins and marketplaces declared in your repo's `.claude/settings.json`"을 클라우드에서 사용할 수 없다(No)고 적고 있습니다. 그래서 `caveman@caveman`은 로컬에서만 동작합니다. (문서: code.claude.com/docs/en/cloud-environments, What carries over from your setup)
- `install_pkgs.sh`는 `github.com`에서 다른 저장소를 clone합니다. 클라우드의 GitHub 프록시는 세션에 연결되지 않은 저장소의 archive 요청을 403으로 막는다고 문서에 있습니다. git clone도 막히는지는 확인하지 못했습니다. (문서 확인, 동작은 추정)
- AGENTS.md Skills 절의 "스킬이 별도 계획/설계 파일을 만들지 않습니다"는 Superpowers 기본 동작(`docs/superpowers/specs|plans/`에 기록)과 충돌합니다.

## 2. Superpowers 분석 (obra/superpowers, 커밋 `2ce8aa1`, v7.0.1)

### 구성 (확인: 저장소 클론)
- 스킬 15개: brainstorming, writing-plans, executing-plans, subagent-driven-development, test-driven-development, systematic-debugging, verification-before-completion, requesting-code-review, receiving-code-review, finishing-a-development-branch, using-git-worktrees, dispatching-parallel-agents, writing-skills, using-superpowers, diagnosing-superpowers.
- 훅 1개: SessionStart(`startup|clear|compact`)가 `using-superpowers` 본문을 `additionalContext`로 주입합니다. "1%라도 해당하면 스킬을 먼저 호출하라"는 강한 규칙이 여기서 들어옵니다.
- 에이전트·명령 디렉터리는 없습니다. 서브에이전트는 모두 general-purpose에 프롬프트 템플릿을 넣어 띄웁니다.
- Claude Code 외에 Codex, Cursor, Gemini, OpenCode 등 여러 하네스용 매니페스트가 함께 있습니다.

### 작업 흐름
brainstorming(질문, 대안, 설계 승인, `docs/superpowers/specs/` 저장) → writing-plans(`docs/superpowers/plans/`에 작은 Task 단위 계획) → subagent-driven-development(Task마다 구현 서브에이전트와 리뷰 서브에이전트, `.superpowers/sdd/<plan>/`에 git-ignored 원장) → TDD → verification → finishing-a-development-branch(병합, PR, 보류 중 선택).

### 템플릿과 맞물리는 지점
- 계획·설계 파일 위치가 템플릿 규칙과 충돌합니다. 두 파일 모두 docs/ 아래 정본으로 받아들이고 PLAN.md·TASK.md에서 링크하는 쪽이 자연스럽습니다.
- SDD 원장은 git-ignored라서 클라우드 VM 회수 시 사라집니다. 재개 지점은 plan 체크박스와 STATE.md로 남겨야 합니다.
- `using-git-worktrees`는 "선언된 선호가 있으면 묻지 않는다"고 되어 있어 AGENTS.md에서 선호를 선언할 수 있습니다.
- `finishing-a-development-branch`의 선택지는 Git Conventions와 맞춰야 합니다. 클라우드에서는 `gh pr`이 GraphQL 차단으로 실패합니다. (문서: GitHub proxy)

## 3. pstack 분석 (cursor/plugins `pstack/`, 커밋 `519d36a`, v0.15.34)

### 공식 위치
Lauren Tan(poteto)의 pstack 공식 소스는 `github.com/cursor/plugins`의 `pstack/` 디렉터리입니다. Claude Code용 설치 트리는 생성 스크립트가 만든 `harness/pstack/claude-code/`이고, 마켓플레이스(`.claude-plugin/marketplace.json`)가 이 경로를 가리킵니다. `michael-denyer/pstack-claude`, `backnotprop/pstack` 등은 커뮤니티 포트입니다. (확인: 저장소 클론, `gh search repos pstack`)

### 구성 (확인)
- 스킬 58개: 진입점 `poteto-mode`(플레이북 23개), 도움말 `poteto-help`, 설정 `setup-pstack`, 워크플로 스킬(how, why, architect, arena, swarm, interrogate, reflect, tdd, unslop, technical-writing, show-me-your-work, statechart 등), 원칙 스킬 `principle-*` 23개.
- `setup-pstack`을 뺀 57개가 `disable-model-invocation: true`입니다. 모델이 Skill 도구로 부를 수 없고, 사용자가 `/이름`으로 부르거나 에이전트가 SKILL.md를 Read해 따릅니다.
- 에이전트 2개: `poteto-agent`(플레이북 단계의 위임 서브에이전트), `comment-sicko`(주석 제거 리뷰어).
- 훅 없음. Claude Code 어댑터 문서(`docs/harness/claude-code.md`)가 Cursor 이름(Task, readonly, 모델 슬러그, 경로)을 Claude Code 이름으로 바꾸는 표를 제공합니다.
- 모델 규칙: `/setup-pstack`이 역할별 모델을 `~/.claude/rules/pstack-models.md`에 씁니다. 기본값은 코드 위임 grok, 판단·문장 opus 5.5 xhigh입니다. Claude Code에서는 grok이 `inherit-parent`로 바뀝니다.

### 철학과 템플릿과의 긴장
- "계획을 믿지 않는다, 최고의 명세는 코드다." PLAN.md와 긴장이 있습니다.
- never-block-on-the-human: 되돌릴 수 있는 작업은 묻지 않고 진행합니다. 템플릿의 Escalation 목록과 함께 적용해야 합니다.
- 응답 문체 규칙(짧은 평서문, 긴 대시·중간 콜론 금지, 주장마다 근거나 측정·추론·추측 표시)이 강합니다.
- `deslop`, `control-cli`, `control-ui`는 `cursor-team-kit`에 있어 pstack에 없습니다.
- 모델 규칙이 사용자 홈에 있어 클라우드 VM에서는 매번 사라집니다.

## 4. 클라우드 자동 설치 방식 결정

| 방식 | 판단 |
|------|------|
| `.claude/settings.json`의 `enabledPlugins`·`extraKnownMarketplaces` | 클라우드에서 설치되지 않음 (문서) |
| SessionStart 훅에서 `claude plugin install` 실행 | 연결되지 않은 GitHub 저장소 접근이 프록시에 막힐 수 있고, 같은 세션에 로드되는지 보장이 없으며, 매 세션 새 VM이라 매번 다시 받아야 함. 채택하지 않음 (추정 포함) |
| **플러그인 내용을 `.claude/`에 벤더링해 커밋** | 클라우드가 로드한다고 문서에 명시된 `.claude/skills/`, `.claude/agents/`, `.claude/rules/`, settings 훅만 사용. 채택 |

벤더링의 대가는 자동 갱신이 없다는 점입니다. 그래서 각 템플릿에 고정 커밋으로 다시 받아 패치를 재적용하는 스크립트를 두었습니다. 두 플러그인 모두 MIT이며 LICENSE를 함께 넣었습니다.

## 5. 산출물

### `../workspace-template-superpowers/` (로컬 git, 커밋 1개)
- `.claude/skills/` Superpowers 스킬 15개. `superpowers:` 접두사 참조를 제거(48줄).
- `.claude/hooks/superpowers-session-start.sh`: 업스트림 훅을 프로젝트 경로용으로 다시 작성. `.claude/settings.json`에 `startup|clear|compact` 훅으로 등록.
- `enabledPlugins`에서 `superpowers@claude-plugins-official`, `superpowers@superpowers-marketplace`를 false로 두어 로컬 중복 방지.
- AGENTS.md에 Superpowers Workflow 절: 순서(TASK 등록, 설계, 계획, 실행, 디버깅, 리뷰, 완료), 진행 상태 보존, 워크트리 선호, 규모별 생략, 무인 실행 규칙.
- `docs/superpowers/specs|plans/`, `.gitignore`(`.superpowers/`, `.worktrees/`), CHECKLIST의 Superpowers 점검 항목, `scripts/vendor_superpowers.sh`, `.claude/vendor/superpowers/`(UPSTREAM, VENDORED.md, LICENSE).

### `../workspace-template-pstack/` (로컬 git, 커밋 1개)
- `.claude/skills/` 58개, `.claude/agents/`에 `poteto-agent`, `comment-sicko` 추가, `.claude/docs/`(가이드, 어댑터), `.claude/pstack-README.md`.
- `.claude/rules/pstack-models.md`: 어댑터 기본값 변환으로 미리 채운 모델 규칙. 클라우드 세션마다 자동 로드.
- 패치 6종(접두사 제거, 모델 규칙 경로, README·`pstack/skills/` 경로, poteto-agent 경로 탐색, 어댑터 안내 2곳). 대상 문장이 없으면 스크립트가 실패.
- `enabledPlugins`에서 `pstack@cursor-plugins`를 false로 두어 로컬 중복 방지.
- AGENTS.md에 pstack Workflow 절: 어댑터 읽기, 진입점(사소하지 않은 작업은 poteto-mode), 템플릿 규칙과의 조정(작업 등록 우선, 자율 진행과 승인, 계획, 결정 로그, 모델 규칙), Claude Code에서 빠지는 기능, Explore 위임 조정.
- `docs/plans/`, `.gitignore`(`node_modules/`), CHECKLIST의 pstack 점검 항목, `scripts/vendor_pstack.sh`, `.claude/vendor/pstack/`.

## 6. 검증

| 항목 | 결과 |
|------|------|
| 벤더링 스크립트 두 번 실행 | 같은 결과 (두 템플릿 모두) |
| 업스트림과 차이 | Superpowers 21개 파일 48줄, 모두 접두사 제거 |
| 깨진 상대 링크 | Superpowers 0건. pstack은 업스트림에도 있는 `url` 자리표시자 1건과 VENDORED.md 인라인 코드 예시 1건뿐 |
| 남은 `superpowers:`·`pstack:` 스킬 참조 | 0건 |
| 훅 출력 | `jq`로 JSON 파싱 성공, `additionalContext` 3492자 |
| 헤드리스 세션 (`claude -p --setting-sources project`, haiku) | Superpowers: 접두사 없는 스킬 목록, "You have superpowers." 주입, advisor·runner·Explore 로드 확인. pstack: 모델 규칙 줄 인식, poteto-agent·comment-sicko 로드, `/poteto-mode` 슬래시 명령이 스킬 본문을 불러옴 |

### 검증하지 못한 것
- 실제 클라우드 세션(claude.ai/code)에서의 동작. 로컬 헤드리스 테스트와 공식 문서의 로드 규칙으로만 확인했습니다.
- claude.ai 계정에서 Superpowers를 켠 상태로 클라우드에서 열 때 중복 로드 여부.
- 프로젝트(Projects) 클라우드 스레드는 문서상 루트 `CLAUDE.md`와 `.claude/rules/`만 읽으므로, 그 환경에서는 벤더링한 스킬·훅이 로드되지 않을 수 있습니다. (문서)

## 7. 남은 결정

- 두 디렉터리를 GitHub 저장소로 만들어 푸시하고 Template repository를 켤지.
- 기본 템플릿의 `caveman@caveman`도 클라우드에서 설치되지 않는 같은 문제를 어떻게 처리할지 (벤더링 또는 제거).
- pstack과 함께 `cursor-team-kit`(deslop, control-cli, control-ui)도 벤더링할지.

## 출처
- https://github.com/obra/superpowers
- https://github.com/cursor/plugins/tree/main/pstack
- https://code.claude.com/docs/en/cloud-environments
- https://code.claude.com/docs/en/settings (Settings in cloud sessions)
- https://code.claude.com/docs/en/claude-code-on-the-web

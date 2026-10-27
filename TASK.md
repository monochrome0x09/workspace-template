# Current Task

## Task

workspace-template 분석 후, Superpowers·pstack 플러그인에 최적화된 파생 템플릿 두 개(`../workspace-template-superpowers`, `../workspace-template-pstack`)를 만든다.

## Objective

Claude Code Cloud에서 템플릿으로 만든 새 프로젝트를 열면 각 플러그인이 별도 설치 없이 바로 동작하게 한다.

## Requirements

- 현재 workspace-template 구조와 규칙을 분석한다.
- Superpowers 공식 레포(obra/superpowers)와 pstack 공식 레포(cursor/plugins의 pstack)를 분석한다.
- 각 템플릿은 템플릿 폴더 내부 `.claude/`를 사용해 플러그인을 제공한다.
- 클라우드 세션에서 자동으로 플러그인이 적용되도록 구성한다.
- 각 템플릿의 AGENTS.md 등 규칙을 해당 플러그인 워크플로와 맞춘다.

## Inputs

- 이 저장소의 전체 파일
- https://github.com/obra/superpowers
- https://github.com/cursor/plugins/tree/main/pstack
- Claude Code 공식 문서(cloud environments, settings)

## Out of Scope

- 새 GitHub 저장소 생성·푸시, Template repository 설정 (사용자 승인 필요)
- 이 템플릿(workspace-template) 자체의 규칙 변경

## Deliverables

- `../workspace-template-superpowers/` (git init, 로컬 커밋)
- `../workspace-template-pstack/` (git init, 로컬 커밋)
- `outputs/plugin-templates-analysis.md` (분석 보고서)

## Done When

- 두 디렉터리에 플러그인이 `.claude/`에 벤더링되어 있고 출처·커밋·패치가 기록되어 있다.
- 각 템플릿에서 헤드리스 세션으로 스킬·에이전트·훅 로드가 확인된다.
- 깨진 상대 링크와 남은 플러그인 네임스페이스 참조가 0건이다.
- 분석 보고서가 outputs/에 있다.

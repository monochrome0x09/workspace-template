# Current Task

## Task

현재 저장소 전체 분석

## Objective

저장소의 목적, 구성, 운영 흐름, 현재 준비도와 개선 우선순위를 내부 근거로 설명한다.

## Requirements

- 주요 문서, 에이전트 설정, Git 상태 및 구현·검증 구성 확인
- 확인된 사실과 평가·권고, 미검증 사항 구분
- 기존 운영 규칙과 설정은 수정하지 않음

## Inputs

- README.md, AGENTS.md, PROJECT.md, PLAN.md, CHECKLIST.md
- 초기 TASK.md·STATE.md와 .claude/ 설정
- 로컬 Git 이력 및 파일 목록

## Out of Scope

- 기능 구현, 리팩터링, 의존성 설치
- 외부 서비스 설정 및 에이전트 실행 호환성 검증

## Deliverables

- outputs/project-analysis.md
- 현재 작업과 분석 결과를 반영한 TASK.md 및 STATE.md

## Done When

- 전체 구성과 주요 판단에 파일 근거가 연결되어 있다.
- 관련 문서·설정과 산출물을 검증하고 검증 한계를 기록한다.
- 변경을 커밋하고 기존 작업 브랜치로 푸시한다. 실패 시 STATE.md에 기록한다.

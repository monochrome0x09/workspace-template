# workspace-template

Claude Code(클라우드 포함)에서 프로젝트를 일관된 방식으로 시작하기 위한 작업 공간 템플릿입니다. 에이전트 지침과 작업 상태를 파일로 관리해서, 세션이 바뀌어도 이어서 작업할 수 있게 합니다.

## 사용 방법

1. GitHub에서 **Use this template**으로 새 저장소를 만듭니다. (이 저장소의 Settings에서 Template repository가 켜져 있어야 보입니다.)
2. `PROJECT.md`를 채웁니다. 개발 프로젝트가 아니면 Development 섹션을 지웁니다. 모르는 항목은 `TBD`로 둡니다.
3. `TASK.md`에 첫 작업을 적습니다.
4. 중대규모 프로젝트라면 `PLAN.md`를 채우고, 아니면 삭제합니다.
5. Claude Code에서 저장소를 열고 작업을 요청합니다.

## 구조

| 경로 | 역할 |
|------|------|
| `CLAUDE.md` | `AGENTS.md`를 불러오는 진입점 |
| `AGENTS.md` | 에이전트 규칙 (읽기 순서, 완료 절차, Git, 승인 기준) |
| `PROJECT.md` | 장기 프로젝트 정보 |
| `TASK.md` | 현재 작업 하나 |
| `STATE.md` | 진행 상태와 현재 단계 |
| `PLAN.md` | 전체 계획 (선택) |
| `CHECKLIST.md` | 완료 전 점검 기준 (수정하지 않음) |
| `docs/` | 정본과 근거 자료, `docs/decisions/`에는 결정 기록 |
| `outputs/` | 최종 산출물 |

## 클라우드 세션 참고

클라우드 세션은 종료되면 로컬 파일이 사라집니다. 작업 상태와 산출물은 커밋하고 푸시해야 보존됩니다. 자세한 규칙은 `AGENTS.md`의 Git & Persistence를 참고합니다.

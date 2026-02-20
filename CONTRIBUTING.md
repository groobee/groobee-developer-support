# Contributing Guide

이 저장소(groobee-developer-support)는 Groobee 사용/연동 안내 문서를 관리합니다.  
문서 품질과 히스토리 보호를 위해 `main` 브랜치는 보호되어 있으며, 모든 변경은 PR로 반영해야합니다.

---

## 브랜치 정책

### main 브랜치
- `main` 브랜치는 **완성본(배포/공유 가능한 문서)** 만 유지합니다.
- `main` 브랜치에는 **직접 push 하지 않습니다.**
- 변경은 반드시 PR(Pull Request)로 반영합니다.

### draft 브랜치
- 문서 작업은 `draft/*` 브랜치에서 진행합니다.
- main 브랜치에 반영된 draft 브랜치는 삭제합니다.

예시:
- `draft/web-script-installation`
- `draft/ios-sdk-installation`

### patch 브랜치
- 오타 등 간단한 수정은 `patch/*` 브랜치에서 진행합니다.
- main 브랜치에 반영된 patch 브랜치는 삭제합니다.

예시:
- `patch/gettingstart-web-header-size`
- `patch/web-script-installation-typo`

---

## 병합 주의 사항
- 깔끔한 히스토리 관리를 위해 squash 머징을 권장합니다.
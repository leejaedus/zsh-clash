# zsh-clash PRD (Product Requirements Document)

## Overview

zsh-clash는 자연어 설명을 쉘 명령어로 변환하는 zsh 플러그인이다.
Claude Code CLI를 백엔드로 사용한다.

## Core Feature

`# <설명>` 형식으로 입력하고 Enter를 누르면 해당하는 쉘 명령어가 생성된다.

### Example

```
입력: # 현재 디렉토리에서 1MB 이상인 파일 찾기
결과: find . -size +1M -exec ls -lh {} \;
```

## Technical Spec

### Trigger

- 입력이 `#` (또는 설정된 prefix)로 시작할 때
- Enter 키를 누르면 활성화

### Exceptions (Pass-through)

- `#!`로 시작하는 shebang
- 멀티라인 버퍼
- 빈 설명 (`#` 만 입력)

### Flow

1. 사용자가 `# <설명>` 입력 후 Enter
2. 원래 입력을 히스토리에 저장
3. 스피너 애니메이션 표시
4. Claude CLI 호출 (`claude -p --model <model>`)
5. 응답에서 마크다운/코드블록 제거
6. 결과를 버퍼에 표시
7. 사용자가 확인 후 Enter로 실행

### Configuration

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `CLASH_DISABLED` | 0 | 1로 설정 시 비활성화 |
| `CLASH_MODEL` | haiku | Claude 모델 (haiku/sonnet/opus) |
| `CLASH_DEBUG` | 0 | 1로 설정 시 디버그 출력 |
| `CLASH_FANCY_LOADING` | 1 | 0으로 설정 시 스피너 비활성화 |
| `CLASH_PREFIX` | # | 트리거 prefix 문자 |

## Dependencies

- zsh
- Claude Code CLI (`claude` command)

## Non-Goals

- bash 지원
- 다중 명령어 생성
- 명령어 자동 실행 (사용자 확인 필수)

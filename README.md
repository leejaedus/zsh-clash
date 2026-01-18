# zsh-clash

자연어를 쉘 명령어로 변환하는 zsh 플러그인. Claude Code CLI 기반.

## 사용법

```bash
# 1MB 이상 파일 찾기
```

Enter를 누르면:

```bash
find . -size +1M -exec ls -lh {} \;
```

## 설치

### 요구사항

- zsh
- [Claude Code CLI](https://claude.ai/download)

### oh-my-zsh

```bash
git clone https://github.com/leejaedus/zsh-clash ~/.oh-my-zsh/custom/plugins/zsh-clash
```

`~/.zshrc`:

```bash
plugins=(... zsh-clash)
```

### 수동 설치

```bash
git clone https://github.com/leejaedus/zsh-clash ~/.zsh-clash
echo 'source ~/.zsh-clash/clash.plugin.zsh' >> ~/.zshrc
```

### 적용

```bash
source ~/.zshrc
```

## 설정

`~/.zshrc`에 추가:

```bash
# 모델 변경 (기본: haiku)
export CLASH_MODEL="sonnet"

# 비활성화
export CLASH_DISABLED=1

# 스피너 끄기
export CLASH_FANCY_LOADING=0

# prefix 변경 (기본: #)
export CLASH_PREFIX="?"

# 디버그 모드
export CLASH_DEBUG=1
```

## License

MIT

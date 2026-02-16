# zsh-clash

A zsh plugin that converts natural language to shell commands. Powered by Claude Code CLI.

## LLM Quick Context

- Runtime: zsh widget (`accept-line`) in `zsh-clash.plugin.zsh`
- Trigger: input starts with `#` (default)
- Core contract: `Ctrl+C` must cancel in-flight command generation
- Primary install path: `~/.oh-my-zsh/custom/plugins/zsh-clash`
- Verification priority: interactive shell behavior over static checks

## Usage

```bash
# find files larger than 1MB
```

Press Enter:

```bash
find . -size +1M -exec ls -lh {} \;
```

## Installation

### Requirements

- zsh
- [Claude Code CLI](https://claude.ai/download)

### oh-my-zsh

```bash
# Fresh install
git clone https://github.com/leejaedus/zsh-clash ~/.oh-my-zsh/custom/plugins/zsh-clash

# Update (if already installed)
git -C ~/.oh-my-zsh/custom/plugins/zsh-clash pull
```

Add to plugins in `~/.zshrc`:

```bash
# Auto-add (macOS/Linux compatible)
perl -i -pe 's/plugins=\(/plugins=(zsh-clash /' ~/.zshrc
```

### Manual Installation

```bash
# Fresh install
git clone https://github.com/leejaedus/zsh-clash ~/.zsh-clash
echo 'source ~/.zsh-clash/zsh-clash.plugin.zsh' >> ~/.zshrc

# Update (if already installed)
git -C ~/.zsh-clash pull
```

### Apply Changes

```bash
source ~/.zshrc
```

## Developer Workflow (LLM-Friendly)

1. Edit `zsh-clash.plugin.zsh`
2. Run syntax check:

```bash
zsh -n zsh-clash.plugin.zsh
```

3. Verify interactive behavior in real shell (tmux recommended for reproducibility)
4. If using oh-my-zsh install path, verify user update flow:

```bash
git -C ~/.oh-my-zsh/custom/plugins/zsh-clash pull
source ~/.zshrc
```

## Interrupt Verification Checklist

- Start generation with a `# ...` prompt
- Press `Ctrl+C` while spinner is active
- Expected: immediate prompt recovery and generation process canceled
- Repeat once with `CLASH_FANCY_LOADING=0` to validate no-spinner path

## Configuration

Add to `~/.zshrc`:

```bash
# Change model (default: haiku)
export CLASH_MODEL="sonnet"

# Disable plugin
export CLASH_DISABLED=1

# Disable spinner
export CLASH_FANCY_LOADING=0

# Change prefix (default: #)
export CLASH_PREFIX="?"

# Debug mode
export CLASH_DEBUG=1
```

## License

MIT

# zsh-clash

A zsh plugin that converts natural language to shell commands. Powered by Claude Code CLI.

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

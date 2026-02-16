# Project Conventions (zsh-clash)

## Runtime Verification
- For interactive behavior changes (spinner, signal handling, ZLE widgets), do not claim completion with static checks only.
- Validate with an actual interactive shell session; when available, verify in tmux as terminal proxy.

## Installation-Path Parity
- Treat `~/.oh-my-zsh/custom/plugins/zsh-clash` as a primary user install path.
- After push, verify update flow using:
  - `git -C ~/.oh-my-zsh/custom/plugins/zsh-clash pull`
  - `source ~/.zshrc` (or the user's actual rc file)

## Interrupt Behavior Contract
- `Ctrl+C` must cancel in-flight command generation by default, without requiring extra commands.
- Any change touching generation flow must include interrupt-path verification.

## Response Style
- Keep responses concise and action-first.
- When user requests `커밋 푸시`, perform commit and push directly, excluding unrelated local artifacts (e.g., `.pep/`).

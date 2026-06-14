#!/usr/bin/env zsh
# Claude Code status line — mirrors p10k lean prompt: dir + vcs + model
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')

# Load hash -d named-directory mappings (dirs.zsh + _local.zsh)
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
[[ -f "$DOTFILES/dirs.zsh" ]] && source "$DOTFILES/dirs.zsh"
[[ -f "$DOTFILES/_local.zsh" ]] && source "$DOTFILES/_local.zsh"

# Substitute ~ and any hash -d aliases
display_cwd="${(D)cwd}"

# Git info
git_info=""
if git -C "$cwd" rev-parse --git-dir &>/dev/null; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  git_status=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
  if [ -n "$git_status" ]; then
    # dirty — yellow
    git_info=" $(printf '\033[38;5;220m')${branch}*$(printf '\033[0m')"
  else
    # clean — green
    git_info=" $(printf '\033[38;5;76m')${branch}$(printf '\033[0m')"
  fi
fi

# Model in blue, cwd in cyan, git branch in green/yellow
printf "$(printf '\033[38;5;39m')%s$(printf '\033[0m') $(printf '\033[38;5;45m')%s$(printf '\033[0m')%s" \
  "$model" "$display_cwd" "$git_info"

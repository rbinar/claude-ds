# cli-dispatch demo — vhs tape (Claude Code CLI look, mock / key-free)
# Render:  vhs demo.tape   ->   demo.gif
#
# Simulates a Claude Code session, install → test:
#   1. /plugin install cli-dispatch@cli-dispatch   (setup)
#   2. /cli-dispatch:ds-setup                        (wrapper + config)
#   3. /cli-dispatch:ds-run …                        (delegate to DeepSeek)
# During step 3 an ACTIVE SUBAGENT status line is pinned at the bottom
# (spinner · elapsed · tokens · esc to interrupt), then the ⏺ / └ tool-use
# transcript appears once it finishes.
# A DEBUG trap (extdebug) intercepts the slash commands off-camera and
# prints the mocked output, then returns non-zero to skip real execution —
# so it renders key-free and deterministically. Outputs are faithful to
# real plugin behavior.

Output demo.gif

Set Shell "bash"
Set FontSize 18
Set Width 1280
Set Height 840
Set Padding 28
Set TypingSpeed 45ms
Set WindowBar Colorful
Set Margin 16
Set BorderRadius 10
Set Theme { "name": "claude-code", "background": "#1c1917", "foreground": "#e7e5e4", "cursor": "#d97757", "selection": "#44403c", "black": "#1c1917", "red": "#f87171", "green": "#4ade80", "yellow": "#fbbf24", "blue": "#60a5fa", "magenta": "#c084fc", "cyan": "#22d3ee", "white": "#e7e5e4", "brightBlack": "#78716c", "brightRed": "#f87171", "brightGreen": "#4ade80", "brightYellow": "#fbbf24", "brightBlue": "#60a5fa", "brightMagenta": "#c084fc", "brightCyan": "#22d3ee", "brightWhite": "#fafaf9" }

# ---- off-camera setup: prompt + slash-command mock (install/setup/run) ----
Hide
Type `PS1=$'\033[38;2;217;119;87m> \033[0m'`
Enter
Type `A=$'\033[38;2;217;119;87m'; D=$'\033[38;5;245m'; G=$'\033[32m'; R=$'\033[0m'; __g=0`
Enter
Type `__cc(){ [ "$__g" = 1 ] && return 0; case "$BASH_COMMAND" in "/plugin install"*) __g=1; echo; printf "%s⏺%s Installed cli-dispatch@cli-dispatch ✓\n" "$A" "$R"; sleep 0.3; printf "  %s└  run /reload-plugins to enable the /cli-dispatch:ds-* commands%s\n\n" "$D" "$R"; __g=0; return 1;; "/cli-dispatch:ds-setup"*) __g=1; echo; printf "%s⏺%s ds-setup\n" "$A" "$R"; sleep 0.35; printf "  %s└  wrapper → ~/.local/bin/claude-ds ✓%s\n" "$D" "$R"; sleep 0.35; printf "  %s└  config  → ~/.config/claude-ds/config (add your DeepSeek key)%s\n" "$D" "$R"; sleep 0.35; printf "  %s└  %s✓ smoke test passed%s\n\n" "$D" "$G" "$R"; sleep 0.3; __g=0; return 1;; "/cli-dispatch:ds-run"*) __g=1; echo; printf "%s⏺%s Delegating to DeepSeek via ds-runner…\n\n" "$A" "$R"; F=(✻ ✢ ✶ ✺ ✵); t=0; for i in $(seq 0 22); do s=${F[$((i%5))]}; sec=$((i/4)); t=$((t+143)); printf "\r%s%s%s ds-runner(delegate to DeepSeek) %s(%ss · %s tokens · esc to interrupt)%s\033[K" "$A" "$s" "$R" "$D" "$sec" "$t" "$R"; sleep 0.2; done; printf "\r\033[K"; printf "%s⏺%s ds-runner(write hello.py + a pytest test)\n" "$A" "$R"; sleep 0.3; printf "  %s└  worker: DeepSeek (deepseek-v4-pro) · isolated git worktree%s\n" "$D" "$R"; sleep 0.3; printf "  %s└  ▸ Write hello.py%s\n" "$D" "$R"; sleep 0.3; printf "  %s└  ▸ Write test_hello.py%s\n" "$D" "$R"; sleep 0.3; printf "  %s└  %s✓ pytest: 1 passed%s\n" "$D" "$G" "$R"; sleep 0.3; printf "  %s└  done — diff left uncommitted for review%s\n" "$D" "$R"; sleep 0.5; echo; printf "%s⏺%s DeepSeek wrote hello.py and a passing test in an isolated\n" "$A" "$R"; printf "  worktree. You review the diff and merge.%s\n" "$R"; echo; __g=0; return 1;; esac; return 0; }`
Enter
Type `shopt -s extdebug; trap '__cc' DEBUG`
Enter
Type "clear"
Enter
Show

# ---- 1. install ----
Sleep 500ms
Type "/plugin install cli-dispatch@cli-dispatch"
Sleep 500ms
Enter
Sleep 1600ms

# ---- 2. setup ----
Type "/cli-dispatch:ds-setup"
Sleep 500ms
Enter
Sleep 2200ms

# ---- 3. test: delegate to DeepSeek ----
Type "/cli-dispatch:ds-run write hello.py that prints hi, with a pytest test"
Sleep 600ms
Enter
Sleep 8000ms

# hold on the final frame
Sleep 2500ms

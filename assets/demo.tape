# cli-dispatch demo — vhs tape (mock / key-free, deterministic)
# Render:  vhs demo.tape   ->   demo.gif
#
# Uses Hide/Show to define mock ds-agent / ds-status functions off-camera,
# so the visible commands look real but need no DeepSeek key and always
# render identically. To make a LIVE version, drop the Hide..Show block
# and ensure ds-setup + a key are configured.

Output demo.gif

Set Shell "bash"
Set FontSize 18
Set Width 1240
Set Height 720
Set Padding 26
Set Theme "Dracula"
Set TypingSpeed 42ms

# ---- off-camera setup: mock the CLIs + a clean prompt ----
Hide
Type `export PS1='\[\e[36m\]~/demo\[\e[0m\] $ '`
Enter
Type `ds-status(){ printf 'claude-ds   installed  ~/.local/bin/claude-ds\nconfig      ok         ~/.config/claude-ds/config (0600)\nkey         set        DEEPSEEK_API_KEY (sk-***)\nclaude CLI  on PATH\nmodel       deepseek-v4-pro\n'; }`
Enter
Type `ds-agent(){ if [ "$1" = "--read-only" ]; then printf '\033[2m▸ worker: DeepSeek (read-only)\033[0m\n\033[2m▸ thinking…\033[0m\n3\n'; else printf '\033[2m▸ worker: DeepSeek (agentic, cwd=/tmp/demo)\033[0m\n\033[2m▸ Write hello.py\033[0m\n\033[2m✓ done\033[0m\n'; mkdir -p /tmp/demo; printf 'print("hi")\n' > /tmp/demo/hello.py; fi; }`
Enter
Type "clear"
Enter
Show

# ---- intro ----
Type "# cli-dispatch — hand a task to DeepSeek as a worker"
Enter
Sleep 1200ms

# ---- status ----
Type "ds-status"
Enter
Sleep 2800ms

# ---- read-only delegation ----
Type "# read-only: worker cannot write files / run bash"
Enter
Sleep 700ms
Type `ds-agent --read-only "how many times does 'r' appear in strawberry?"`
Enter
Sleep 3000ms

# ---- agentic, isolated dir ----
Type "# agentic: generate a file, runs on DeepSeek, isolated cwd"
Enter
Sleep 700ms
Type `ds-agent --cwd /tmp/demo "write hello.py that prints hi"`
Enter
Sleep 2800ms

Type "cat /tmp/demo/hello.py"
Enter
Sleep 2400ms

# ---- closer ----
Type "# orchestrator = Claude · worker = DeepSeek · you review + merge"
Enter
Sleep 3000ms

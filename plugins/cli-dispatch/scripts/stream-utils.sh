# stream-utils.sh — shared helpers for worker stream wrappers.
#
# Source this file from the stream scripts (ag-stream, cx-stream, claude-ds-stream)
# to avoid duplicating process-tree management, config resolution, and session-root
# resolution across backends.
#
# Usage:
#   . "$(dirname "${BASH_SOURCE[0]}")/stream-utils.sh"

# ---- cross-platform mtime ----
mtime_of() { stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null; }

# ---- process-tree helpers ----

# Recursive kill by PID (leaves-first).
kill_tree() {
  local pid="$1" sig="${2:--TERM}" child
  for child in $(pgrep -P "$pid" 2>/dev/null); do kill_tree "$child" "$sig"; done
  kill "$sig" "$pid" 2>/dev/null || true
}

# Snapshot a pid + all descendants (newline-separated, numeric → safe to word-split).
proc_tree() {
  local pid="$1" child
  for child in $(pgrep -P "$pid" 2>/dev/null); do proc_tree "$child"; done
  printf '%s\n' "$pid"
}

# Hard-kill the worker subtree. CRITICAL: some workers (e.g. agy) ignore SIGTERM and
# reparent to init once their parent dies, so a naive "TERM then KILL" misses them.
# Snapshot the whole subtree FIRST, TERM it (graceful for well-behaved children), then
# KILL the SAME captured pids — so reparented processes are not missed.
# (bash-3.2 safe: no mapfile.)
kill_worker() {
  local root="$1" tree p
  tree="$(proc_tree "$root")"
  for p in $tree; do kill -TERM "$p" 2>/dev/null || true; done
  sleep 3
  for p in $tree; do kill -KILL "$p" 2>/dev/null || true; done
}

# ---- config resolution ----

# Resolve and source the cli-dispatch config file (env wins; legacy claude-ds fallback).
# Sets variables from the config into the caller's scope.
source_config() {
  local config="${CLI_DISPATCH_CONFIG:-${CLAUDE_DS_CONFIG:-}}"
  if [ -z "$config" ]; then
    config="$HOME/.config/cli-dispatch/config"
    [ -f "$config" ] || [ ! -f "$HOME/.config/claude-ds/config" ] || config="$HOME/.config/claude-ds/config"
  fi
  if [ -f "$config" ]; then
    # shellcheck disable=SC1090
    . "$config"
  fi
}

# ---- sessions-root resolution ----

# Resolve the sessions root directory (env wins; legacy claude-ds fallback).
# Prints the resolved path to stdout.
resolve_sessions_root() {
  local root="${CLI_DISPATCH_SESSIONS_DIR:-${CLAUDE_DS_SESSIONS_DIR:-}}"
  if [ -z "$root" ]; then
    local _c="${XDG_CACHE_HOME:-$HOME/.cache}"
    root="$_c/cli-dispatch/sessions"
    [ -d "$root" ] || [ ! -d "$_c/claude-ds/sessions" ] || root="$_c/claude-ds/sessions"
  fi
  printf '%s' "$root"
}

---
description: claude-ds wrapper'ini kur ve yapilandir
allowed-tools: Bash
---

# claude-ds kurulum

Aşağıdaki adımları uygula:

1. Wrapper'ı kur — işletim sistemine göre:
   - **macOS / Linux / WSL / Git Bash** (bash mevcut):
     ```bash
     bash "${CLAUDE_PLUGIN_ROOT}/scripts/install.sh"
     ```
   - **Native Windows** (PowerShell):
     ```powershell
     powershell -NoProfile -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/install.ps1"
     ```
   İkisi de `~/.local/bin`'e wrapper'ı kurar (Windows'ta `claude-ds.ps1` + `claude-ds.cmd` shim) ve yoksa `~/.config/claude-ds/config` iskeletini oluşturur. OS'u tespit edip uygun olanı çalıştır.

2. **API key'i kullanıcı kendisi eklemeli.** Kullanıcıdan DeepSeek API key'ini
   `~/.config/claude-ds/config` içindeki `DEEPSEEK_API_KEY=""` satırına eklemesini iste.
   **Sen (Claude) API key'i ASLA yazma/yapıştırma** — API key girişi yasaktır. Key'i sadece kullanıcı girer.

3. `claude` CLI'ın kurulu olduğunu doğrula: `command -v claude`.

4. Kullanıcı key'i eklediğini doğruladıktan sonra, opsiyonel smoke test (background task olarak):
   ```bash
   claude-ds -p "Reply with exactly: OK"
   ```

**Uyarı:** claude-ds'e verdiğin prompt/kod DeepSeek'e (harici servis) gönderilir. Bunu yalnızca kabul ediyorsan kullan.

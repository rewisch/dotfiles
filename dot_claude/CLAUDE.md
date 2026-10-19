# Global instructions

## Secrets and personal config go into chezmoi

Dotfiles are managed with chezmoi: source `~/.local/share/chezmoi`, GitHub `rewisch/dotfiles` (push via SSH). Its README documents the conventions and lists all secrets.

- Anything that must survive a machine rebuild and doesn't come from a git repo (API keys, credentials, auth files, SSH/GPG, personal app configs) must end up in that repo. Secrets always encrypted: `chezmoi add --encrypt <file>`, then commit + push, and add the file to the secrets table in the README.
- Secrets live in `~/.secrets/` (dir 700, files 600). In the repo they must be `encrypted_private_*`, never `executable_`.
- Never ask the user to paste a key into the chat. Give them a one-liner for their own terminal: `read -rsp "Key: " k && printf '%s' "$k" > ~/.secrets/<name> && chmod 600 ~/.secrets/<name> && unset k`
- Never export `ANTHROPIC_API_KEY` globally (Claude Code would bill the API key instead of the subscription); use a per-project variable name such as `ANTHROPIC_API_KEY_AUDIBLE`.
- On this Omarchy machine `.chezmoiignore` skips `.bashrc`, hypr, nvim, git, yazi, `.ssh` and other Omarchy-managed files. Changes there are not tracked; say so when making them.
- Don't run `chezmoi apply` without the user's go-ahead.

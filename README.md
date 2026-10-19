# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Neuer Rechner

```bash
chezmoi init --apply git@github.com:rewisch/dotfiles.git
```

Beim ersten `apply` wird nach der Passphrase für `key.txt.age` gefragt. Damit wird der
age-Schlüssel nach `~/.config/chezmoi/key.txt` entschlüsselt; danach importiert
`run_after_import-gpg.sh` die GPG-Keys samt Ownertrust.

Nur anschauen, nichts anwenden:

```bash
chezmoi init git@github.com:rewisch/dotfiles.git
chezmoi status    # was würde sich ändern
chezmoi diff
```

## Regel: Secrets und persönliche Configs gehören hierher

Alles, was auf einem neuen Rechner wieder da sein muss und nicht aus einem Git-Repo
kommt (API-Keys, Credentials, Auth-Files, SSH/GPG), wird hier abgelegt, **immer
verschlüsselt**:

```bash
chezmoi add --encrypt ~/.secrets/<name>
cd ~/.local/share/chezmoi && git add -A && git commit -m "..." && git push
```

- Secrets liegen unter `~/.secrets/` (Ordner 700, Dateien 600).
- Im Repo müssen sie `encrypted_private_*.age` heissen. Nie `executable_`, sonst
  landen sie mit 755 auf der Platte.
- Kontrolle vor dem Push: jede `.age`-Datei beginnt mit `age-encryption.org/v1`
  oder `-----BEGIN AGE ENCRYPTED FILE-----`.
- Keys nie im Chat oder in der Shell-History eingeben, sondern so in die Datei schreiben:
  `read -rsp "Key: " k && printf '%s' "$k" > ~/.secrets/<name> && chmod 600 ~/.secrets/<name> && unset k`

### Aktuelle Secrets

| Datei | Wofür |
|---|---|
| `~/.secrets/nas.smbcred` | SMB-Login für `//nas.home.arpa/Cloud-Reto` (fstab-Mount `/mnt/nas/Cloud-Reto`) |
| `~/.secrets/anthropic-audible.key` | Claude-API-Key für `~/src/audible` (`ANTHROPIC_API_KEY_AUDIBLE`) |
| `~/.audible/*` | audible-cli Profile `reto` und `livia` |
| `~/.ssh/*` | alter SSH-Key, auf Omarchy ausgeschlossen (siehe unten) |
| `tmp-gpg-export/` | GPG-Keys + Ownertrust, nur für das Import-Skript |
| `~/.claude/CLAUDE.md` | globale Anweisungen für Claude Code (nicht geheim, aber persönlich) |

`ANTHROPIC_API_KEY` nie global exportieren: Claude Code würde sonst über den
API-Key statt über das Abo abrechnen. Darum der eigene Variablenname pro Projekt.

## Omarchy

Auf Rechnern mit `/usr/share/omarchy` ignoriert `.chezmoiignore` alles, was Omarchy
selbst verwaltet: `.bashrc`, hypr, waybar, rofi, kitty, btop, nvim, git, lazygit,
yazi, oh-my-posh, `powermenu.sh` und `.ssh`.

Folge: Änderungen an der `.bashrc` (z. B. die `export`-Zeilen für die Keys oben)
sind auf Omarchy **nicht** im Repo und müssen auf einem neuen Rechner von Hand
nachgetragen werden:

```bash
[[ -r ~/.secrets/anthropic-audible.key ]] && export ANTHROPIC_API_KEY_AUDIBLE="$(< ~/.secrets/anthropic-audible.key)"
```

## Ausserhalb von chezmoi (Setup auf neuem Rechner)

- NAS-Mount: Zeile in `/etc/fstab` (cifs, `credentials=~/.secrets/nas.smbcred`,
  `x-systemd.automount`, `nofail`), Mountpoint `/mnt/nas/Cloud-Reto`.
- Audible-Pipeline: `~/src/audible` (rewisch/Audible) und `~/src/audible-cli`
  (rewisch/audible-cli); in `~/src/audible`: `python3 -m venv .venv` und
  `.venv/bin/pip install requests beautifulsoup4 anthropic openai markdown cryptography ../audible-cli/`.

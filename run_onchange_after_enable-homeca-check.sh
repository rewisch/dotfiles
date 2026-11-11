#!/bin/sh
# Enable the weekly certificate-expiry reminder (see ~/.local/share/homeca/RENEWAL.md)
command -v systemctl >/dev/null || exit 0
systemctl --user daemon-reload
systemctl --user enable --now homeca-check.timer

# Vim bridge package

This package declares host-specific Vim installation routes. Its authored
installer options and launch points live in `vibe.toml`; `README.md` explains
their intended use. The Windows archive is identified by its exact URL and
SHA-256, while Ubuntu installation belongs to Apt.

Before changing the package, read `vibe.toml` and `README.md`. Keep platform,
architecture, installer, launcher and public-command names package-authored.
Verify a changed artifact digest against the actual downloaded bytes. Do not
claim a native Windows or Ubuntu installation has passed without running it on
that host.

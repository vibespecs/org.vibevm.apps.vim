# Vim application package

This package connects Vibe's application installer and launchers to upstream
Vim. It requires Vibe 1.0.8 or newer and contains no Vim binaries.

The package author declares two installation choices:

- **Ubuntu, x86_64 — Apt Installer:** runs `apt-get install vim` through the
  system shell, using `sudo` when Vibe is not running as root. The installer
  prints Apt's output and may prompt for a password. The installed files remain
  owned by the operating system; Vibe records `/usr` as the application root
  and invokes `apt-get remove vim` only on an explicit uninstall.
- **Windows, x86_64 — Vim Windows ZIP:** downloads the pinned upstream
  [Vim Windows release](https://github.com/vim/vim-win32-installer/releases/tag/v9.2.1167),
  verifies its SHA-256 digest, and publishes its `vim/` tree under Vibe's
  application host. The package offers `gVim` and terminal `Vim Console`
  launchers. The archive is fetched during installation; it is not stored here.

The platform, architecture, installer and launcher names are authored in
`vibe.toml`. Other platforms and architectures are not declared, so Vibe does
not display or infer them.

`[package].kind = "app"` identifies the package. Each option's
`[installer_options.installation].type` selects how that app is installed;
`shell` and `zip` are installation types, not package kinds. A shell option
always declares `install`, `uninstall`, `force_install`, and `force_uninstall`
commands. Vim's forced Apt install requests `--reinstall`; forced removal
purges the package's system configuration.

```text
vibe app installers org.vibevm.apps/vim --json
vibe install -g org.vibevm.apps/vim --platform ubuntu --arch x86_64 --installer ubuntu-apt
vibe app launchers org.vibevm.apps/vim --json
vibe app run org.vibevm.apps/vim vim
```

On Windows, omit the explicit selection to use host detection, or select
`--platform windows --arch x86_64 --installer windows-zip`. Launch `gvim` with
`vibe app start org.vibevm.apps/vim`.

This bridge's metadata is UPL-1.0. Vim and its Windows build retain their
upstream licenses.

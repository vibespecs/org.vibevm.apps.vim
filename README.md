# Vim application package

This package connects Vibe's application installer and launchers to upstream
Vim. It requires Vibe 1.0.8 or newer and contains no Vim binaries.

The package author declares six installation choices, each written as the
ordered list of steps vibe runs (`vibe app describe org.vibevm.apps/vim --json`
shows them; `vibe app plan … --installer ID` shows what would run on this host
without installing):

- **Ubuntu, x86_64 — Apt Installer:** runs `apt-get install vim` through the
  system shell, using `sudo` when Vibe is not running as root. The installer
  prints Apt's output and may prompt for a password. The installed files remain
  owned by the operating system; Vibe records `/usr` as the application root
  and launches `/usr/bin/vim.basic` directly rather than the `/usr/bin/vim`
  alternatives symlink, so the declared executable is a regular binary. It
  invokes `apt-get remove vim` only on an explicit uninstall. This launcher
  path targets the Ubuntu 26.04 x86_64 Vim package layout; other Ubuntu releases
  or package variants must provide `/usr/bin/vim.basic` at that exact path to
  use this option.
- **Windows, x86_64 — Vim Windows ZIP:** downloads the pinned upstream
  [Vim Windows release](https://github.com/vim/vim-win32-installer/releases/tag/v9.2.1167),
  verifies its SHA-256 digest, and publishes its `vim/` tree under Vibe's
  application host. The package offers `gVim` and terminal `Vim Console`
  launchers. The archive is fetched during installation; it is not stored here.
- **Windows, x86_64 — Build from upstream sources (MinGW-w64):** downloads the
  pinned source tarball and builds console Vim with `mingw32-make -f
  Make_ming.mak` (`recipes/build-windows.cmd`); the step requires the
  `org.vibevm.apps/mingw-w64` package as a build-only dependency: vibe installs
  it hidden when absent and puts its tools on the step's PATH, so nothing but
  Vim lands on the user's PATH.
  The payload holds `vim92\vim.exe` and the runtime tree, like the ZIP option.
- **Linux x86_64, macOS Apple silicon and macOS Intel — Build from upstream sources:** downloads the pinned
  [Vim 9.2.1167 source tarball](https://github.com/vim/vim/archive/refs/tags/v9.2.1167.tar.gz),
  verifies its SHA-256 digest, caches it under Vibe's settings root so a later
  `--offline` install needs no network, and runs `recipes/build-posix.sh`
  (`./configure --prefix="$VIBE_OUT"`, `make`, `make install`; a C compiler,
  `make` and the ncurses development headers must be present; on macOS the
  Xcode command-line tools provide all three). The resulting
  tree is installed as a Vibe-owned, portable payload with a `vim` launcher.

The platform, architecture, installer and launcher names are authored in
`vibe.toml`. Other platforms and architectures are not declared, so Vibe does
not display or infer them.

The public `vim` command belongs to the `vim` alternatives slot. The Windows
option also exposes `gvim`. These names map to this package's launchers; other
packages and versions may provide different names in the same slot. Selecting
the global alternative changes the slot's current pointer. A shell-local
selection changes only that shell's `PATH`.

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

On Linux, `--installer linux-source` builds Vim from the pinned sources; the
first install downloads the tarball, every later one may add `--offline`. On
Windows, omit the explicit selection to use host detection, or select
`--platform windows --arch x86_64 --installer windows-zip`. Launch `gvim` with
`vibe app start org.vibevm.apps/vim`.

This bridge's metadata is UPL-1.0. Vim and its Windows build retain their
upstream licenses.

#!/bin/sh
# Build Vim from the pinned upstream tarball into $VIBE_OUT (Linux and macOS;
# macOS needs the Xcode command-line tools).
#
# vibe lays the tarball out as $VIBE_SOURCES/vim/vim-<version>/ and installs a
# non-empty $VIBE_OUT as the application payload. $VIBE_OUT is a staging path:
# the payload is moved into a storage library afterwards and may be moved
# again, so nothing below may depend on the absolute prefix. Vim bakes its
# prefix in at configure time, so the installed binary is wrapped by a script
# that points $VIM at the payload's own share/vim before starting it.
set -eu
cd "$VIBE_SOURCES"/vim/vim-*/
./configure --prefix="$VIBE_OUT" --with-features=normal --disable-gui --without-x --disable-nls
make -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)"
make install
mv "$VIBE_OUT/bin/vim" "$VIBE_OUT/bin/vim-bin"
cat > "$VIBE_OUT/bin/vim" <<'WRAPPER'
#!/bin/sh
here=$(cd "$(dirname "$0")/.." && pwd)
VIM="$here/share/vim" exec "$here/bin/vim-bin" "$@"
WRAPPER
chmod 755 "$VIBE_OUT/bin/vim"

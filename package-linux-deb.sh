#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$ROOT_DIR/v2rayN/Release/linux-x64"
PACKAGE_NAME="v2rayn"
APP_NAME="v2rayN"
VERSION="7.15.6"
ARCH="amd64"
BUILD_DIR="$ROOT_DIR/v2rayN/Release/deb-build"
PKG_ROOT="$BUILD_DIR/${PACKAGE_NAME}_${VERSION}_${ARCH}"
OUT_DIR="$ROOT_DIR/v2rayN/Release"
DEB_PATH="$OUT_DIR/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

if [[ ! -x "$RELEASE_DIR/v2rayN" ]]; then
    echo "Missing executable: $RELEASE_DIR/v2rayN" >&2
    echo "Run dotnet publish first." >&2
    exit 1
fi

rm -rf "$PKG_ROOT"
mkdir -p \
    "$PKG_ROOT/DEBIAN" \
    "$PKG_ROOT/opt/$APP_NAME" \
    "$PKG_ROOT/usr/bin" \
    "$PKG_ROOT/usr/share/applications" \
    "$PKG_ROOT/usr/share/pixmaps"

rsync -a \
    --exclude 'guiConfigs' \
    --exclude 'guiLogs' \
    --exclude 'guiTemps' \
    --exclude 'guiBackups' \
    --exclude 'NotifyIcon*.panel-v*.png' \
    "$RELEASE_DIR/" "$PKG_ROOT/opt/$APP_NAME/"

chmod 0755 "$PKG_ROOT/opt/$APP_NAME/v2rayN"
find "$PKG_ROOT/opt/$APP_NAME" -type d -exec chmod 0755 {} +
find "$PKG_ROOT/opt/$APP_NAME" -type f -name '*.so' -exec chmod 0755 {} +
find "$PKG_ROOT/opt/$APP_NAME/bin" -type f -exec chmod 0755 {} + 2>/dev/null || true

cat > "$PKG_ROOT/usr/bin/v2rayN" <<'EOF'
#!/usr/bin/env bash
cd /opt/v2rayN
exec /opt/v2rayN/v2rayN "$@"
EOF
chmod 0755 "$PKG_ROOT/usr/bin/v2rayN"

install -m 0644 "$RELEASE_DIR/v2rayN.png" "$PKG_ROOT/usr/share/pixmaps/v2rayN.png"

cat > "$PKG_ROOT/usr/share/applications/v2rayN.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=v2rayN
Comment=A GUI client for proxy tools
Exec=v2rayN
Icon=v2rayN
Terminal=false
Categories=Network;
StartupNotify=false
EOF
chmod 0644 "$PKG_ROOT/usr/share/applications/v2rayN.desktop"

INSTALLED_SIZE="$(du -sk "$PKG_ROOT" | awk '{print $1}')"
cat > "$PKG_ROOT/DEBIAN/control" <<EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: net
Priority: optional
Architecture: $ARCH
Installed-Size: $INSTALLED_SIZE
Maintainer: local build <local@example.com>
Depends: libc6, libx11-6, libxrandr2, libxi6, libxcursor1, libxinerama1, libfontconfig1, libfreetype6, libdbus-1-3
Description: v2rayN desktop client
 A desktop GUI client for proxy tools.
EOF
chmod 0644 "$PKG_ROOT/DEBIAN/control"

dpkg-deb --build --root-owner-group "$PKG_ROOT" "$DEB_PATH"
echo "$DEB_PATH"

#!/bin/sh
# Build tdsm-fixes.jar and put it ahead of tdsm.jar on Top Down Sprite Maker's classpath.
# With --check, exit 0 when the installed fixes match this tdsm.jar and these sources.
set -eu

dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
app="${TDSM_APP:-/Applications/Top Down Sprite Maker.app}"
lib="$app/Contents/app"
cfg="$lib/Top Down Sprite Maker.cfg"
jar="$lib/tdsm.jar"
fixes="$lib/tdsm-fixes.jar"
stamp="$lib/tdsm-fixes.stamp"
runtime="$app/Contents/runtime/Contents/Home/bin/java"
# $APPDIR is expanded by the app's launcher, not here.
# shellcheck disable=SC2016
entry='app.classpath=$APPDIR/tdsm-fixes.jar'

# The stamp ties an install to the jar it patched, so an app update or a source change
# both register as out of date.
fingerprint() {
  {
    cat "$jar"
    find "$dir" -type f \( -name '*.java' -o -name 'apply.sh' \) | LC_ALL=C sort | while read -r f; do cat "$f"; done
  } | shasum -a 256 | cut -d' ' -f1
}

installed() {
  [ -f "$fixes" ] &&
    [ "$(grep -m1 '^app.classpath=' "$cfg")" = "$entry" ] &&
    [ "$(cat "$stamp" 2>/dev/null)" = "$(fingerprint)" ]
}

if [ "${1:-}" = "--check" ]; then
  installed
  exit
fi

[ -f "$jar" ] || { echo "tdsm.jar not found in $app" >&2; exit 1; }

# macOS ships a /usr/bin/javac stub that only offers to install Java, so Homebrew's comes first.
javac="$(brew --prefix openjdk 2>/dev/null)/bin/javac"
[ -x "$javac" ] || javac="$(command -v javac || true)"
"$javac" -version >/dev/null 2>&1 || { echo "no working javac; install openjdk" >&2; exit 1; }
jartool="$(dirname -- "$javac")/jar"

build="$(mktemp -d)"
trap 'rm -rf "$build"' EXIT

# --release 17 matches the JVM bundled with the app, which also runs the tools below.
"$javac" --release 17 -cp "$jar" -d "$build/classes" "$dir/src/com/jordanbunke/sorkin/GenericFileDialog.java"
"$javac" --release 17 -d "$build/tools" "$dir/tools/PatchStyle.java" "$dir/tools/LinkCheck.java"
"$runtime" -cp "$build/tools" PatchStyle "$jar" "$build/classes"
"$jartool" cf "$build/tdsm-fixes.jar" -C "$build/classes" .
"$runtime" -cp "$build/tools:$build/tdsm-fixes.jar:$jar" LinkCheck com.jordanbunke.tdsm.data.style.Style

cp "$build/tdsm-fixes.jar" "$fixes"
awk -v entry="$entry" '
  $0 == entry { next }
  /^app\.classpath=/ && !done { print entry; done = 1 }
  { print }
' "$cfg" > "$build/app.cfg"
cat "$build/app.cfg" > "$cfg"
fingerprint > "$stamp"

# Changing the bundle breaks its seal; an ad-hoc signature is what the app ships with.
codesign --force --sign - --preserve-metadata=identifier,entitlements,requirements,flags "$app"
codesign --verify --deep --strict "$app"

if pgrep -f "$app/Contents/MacOS/" >/dev/null; then
  echo "Restart Top Down Sprite Maker to load the fixes."
fi

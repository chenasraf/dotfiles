#!/usr/bin/env zsh

build-apk() {
  set -euo pipefail

  # --- Helpers ---
  die() {
    echo "Error: $*" >&2
    return 1
  }

  # --- Ensure we're at project root ---
  [[ -f "pubspec.yaml" ]] || die "pubspec.yaml not found. Run this from your Flutter project root."

  # --- Extract name and version from pubspec.yaml (top-level keys) ---
  name="$(awk '
    /^[[:space:]]*#/ {next}
    /^[[:space:]]*name:[[:space:]]*/ {sub(/^[[:space:]]*name:[[:space:]]*/,""); print; exit}
  ' pubspec.yaml)"
  version="$(awk '
    /^[[:space:]]*#/ {next}
    /^[[:space:]]*version:[[:space:]]*/ {sub(/^[[:space:]]*version:[[:space:]]*/,""); print; exit}
  ' pubspec.yaml)"

  [[ -n "${name:-}" ]] || die "Could not parse 'name' from pubspec.yaml"
  [[ -n "${version:-}" ]] || die "Could not parse 'version' from pubspec.yaml"

  # Sanitize for filename: spaces -> '-', plus '+' -> '-'
  safe_name="$(echo "$name" | tr ' ' '-')"
  safe_version="$version" # "$(echo "$version" | tr ' ' '-' | sed 's/+/-/g')"

  echo "App name:    $name"
  echo "App version: $version"

  # --- Build APK (release) ---
  echo "Building APK..."
  flutter build apk

  # --- Locate the newest APK produced by Flutter ---
  echo "Locating built APK..."
  apk_path="build/app/outputs/flutter-apk/app-release.apk"
  [[ -n "${apk_path:-}" && -f "$apk_path" ]] || die "No APK found in build/app/outputs"

  echo "Found APK: $apk_path"

  # --- Copy to release/apk as {name}-{version}.apk ---
  mkdir -p release/apk
  dest="release/apk/${safe_name}-${safe_version}.apk"
  filename="$(basename "$dest")"
  cp -f "$apk_path" "$dest"
  echo "Copied to: $dest"

  # --- Ask whether to connect to remote device ---
  printf "Connect to remote device and install? [y/N] "
  read answer
  case "${answer:-}" in
  y | Y | yes | YES)
    # Device host byte and port with defaults if user just hits enter
    printf "Enter device (last octet of 192.168.68.X) [default 100]: "
    read device_octet
    device_octet="${device_octet:-100}"
    printf "Enter adb TCP/IP port [default 5555]: "
    read port
    port="${port:-5555}"

    target="192.168.68.${device_octet}:${port}"

    command -v adb >/dev/null 2>&1 || die "adb not found. Please install Android Platform Tools."
    echo "Connecting to $target ..."
    adb connect "$target" || die "Failed to connect to $target"

    echo "Pushing APK to /sdcard/Downloads on $target ..."
    adb -s "$target" push "$dest" /sdcard/Downloads/$filename || die "adb push failed"

    echo "Installing via flutter to $target ..."
    flutter install -d "$target"

    echo "Done."
    ;;
  *)
    echo "Skipping remote connect/install. Done."
    ;;
  esac

}

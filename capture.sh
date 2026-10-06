#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p pwd
: "${RUNTIME_DIR:?RUNTIME_DIR must be set}"
/usr/bin/time -p bash -c 'test -n "${CAPTURE_URL:-}" || { echo "CAPTURE_URL must be set" >&2; exit 1; }'
/usr/bin/time -p bash -c 'test -n "${CAPTURE_DIR:-}" || { echo "CAPTURE_DIR must be set" >&2; exit 1; }'
echo "Capturing $CAPTURE_URL -> $CAPTURE_DIR"
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
set +e
/usr/bin/time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
status=$?
set -e
/usr/bin/time -p bash -c 'test -f "$0/final-desktop.png"' "$CAPTURE_DIR"
/usr/bin/time -p bash -c 'test -f "$0/final-mobile.png"' "$CAPTURE_DIR"
/usr/bin/time -p ls -lh "$CAPTURE_DIR/final-desktop.png" "$CAPTURE_DIR/final-mobile.png"
echo "Capture done (exit $status), app left running."
exit $status

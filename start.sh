#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p pwd
PROJECT_ROOT="$(pwd)"
PORT="${PORT:-3000}"
OPENCODE_WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
DIST="$PROJECT_ROOT/dist"
/usr/bin/time -p mkdir -p "$DIST" "$OPENCODE_WEB_DIR"
/usr/bin/time -p test -f index.html
if /usr/bin/time -p test -f package.json; then
  /usr/bin/time -p npm install --no-audit --no-fund
  /usr/bin/time -p bash -c 'node -e "const p=require(\"./package.json\"); process.exit(p.scripts&&p.scripts.build?0:1)" && npm run build || true'
else
  /usr/bin/time -p cp -f index.html "$DIST/index.html"
  /usr/bin/time -p cp -f walk_cycle_2x1.png "$DIST/walk_cycle_2x1.png"
fi
/usr/bin/time -p test -f "$DIST/index.html"
PROJ="$PROJECT_ROOT" DIST="$DIST" OUT="$OPENCODE_WEB_DIR/deployment-output.json" /usr/bin/time -p python3 -c "import json,os; open(os.environ['OUT'],'w').write(json.dumps({'project':os.environ['PROJ'],'directory':os.environ['DIST']}))"
/usr/bin/time -p cat "$OPENCODE_WEB_DIR/deployment-output.json"
echo "Serving $DIST on port $PORT"
exec /usr/bin/time -p python3 -m http.server "$PORT" --directory "$DIST"

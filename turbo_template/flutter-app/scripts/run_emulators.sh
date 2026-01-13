#!/bin/bash
#
# Starts Firebase emulators with dynamic port allocation.
#
# Usage:
#   ./scripts/run_emulators.sh              # Use default ports
#   PORT_BASE=92 ./scripts/run_emulators.sh # Use custom port base (92xx)
#
# Environment Variables:
#   PORT_BASE - Two-digit prefix for ports (default: 91)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$PROJECT_ROOT")"
FIREBASE_DIR="$REPO_ROOT/firebase"

# Default port base: 91 (results in 91xx ports)
PORT_BASE=${PORT_BASE:-91}

# Calculate ports
AUTH_PORT="${PORT_BASE}99"
FIRESTORE_PORT="${PORT_BASE}80"
FUNCTIONS_PORT="500${PORT_BASE:1}"
STORAGE_PORT="${PORT_BASE}99"
UI_PORT="${PORT_BASE}00"

echo "Starting Firebase emulators with port base: $PORT_BASE"
echo "  Auth:      $AUTH_PORT"
echo "  Firestore: $FIRESTORE_PORT"
echo "  Functions: $FUNCTIONS_PORT"
echo "  Storage:   $STORAGE_PORT"
echo "  UI:        $UI_PORT"
echo ""

# Generate .emulator_ports.json for Flutter consumption
cat > "$PROJECT_ROOT/.emulator_ports.json" << EOF
{
  "auth": $AUTH_PORT,
  "firestore": $FIRESTORE_PORT,
  "functions": $FUNCTIONS_PORT,
  "storage": $STORAGE_PORT,
  "ui": $UI_PORT
}
EOF

echo "Generated .emulator_ports.json"
echo ""

# Check if firebase directory exists
if [ ! -d "$FIREBASE_DIR" ]; then
  echo "Error: firebase/ directory not found at $FIREBASE_DIR"
  exit 1
fi

# Create seed directory if it doesn't exist
mkdir -p "$FIREBASE_DIR/seed"

# Build functions if package.json exists
if [ -f "$FIREBASE_DIR/functions/package.json" ]; then
  echo "Building Cloud Functions..."
  cd "$FIREBASE_DIR/functions"
  if [ ! -d "node_modules" ]; then
    npm install
  fi
  npm run build
  echo ""
fi

# Start emulators
cd "$FIREBASE_DIR"

firebase emulators:start \
  --import=./seed \
  --export-on-exit=./seed \
  --only auth,firestore,functions,storage

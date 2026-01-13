#!/bin/bash
#
# Launches Flutter app connected to Firebase emulators.
#
# Usage:
#   ./scripts/run_flutter.sh                    # Use defaults
#   ./scripts/run_flutter.sh -d iPhone          # Specify device
#   IP=192.168.1.100 ./scripts/run_flutter.sh   # Custom IP for physical device
#
# Environment Variables:
#   IP             - Host IP for emulators (default: 127.0.0.1)
#   AUTH_PORT      - Auth emulator port (default: 9199)
#   FIRESTORE_PORT - Firestore emulator port (default: 9180)
#   FUNCTIONS_PORT - Functions emulator port (default: 5001)
#   STORAGE_PORT   - Storage emulator port (default: 9199)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Try to read ports from .emulator_ports.json if it exists
PORTS_FILE="$PROJECT_ROOT/.emulator_ports.json"
if [ -f "$PORTS_FILE" ]; then
  echo "Reading ports from .emulator_ports.json"
  AUTH_PORT=${AUTH_PORT:-$(grep -o '"auth": [0-9]*' "$PORTS_FILE" | grep -o '[0-9]*')}
  FIRESTORE_PORT=${FIRESTORE_PORT:-$(grep -o '"firestore": [0-9]*' "$PORTS_FILE" | grep -o '[0-9]*')}
  FUNCTIONS_PORT=${FUNCTIONS_PORT:-$(grep -o '"functions": [0-9]*' "$PORTS_FILE" | grep -o '[0-9]*')}
  STORAGE_PORT=${STORAGE_PORT:-$(grep -o '"storage": [0-9]*' "$PORTS_FILE" | grep -o '[0-9]*')}
fi

# Default values
IP=${IP:-127.0.0.1}
AUTH_PORT=${AUTH_PORT:-9199}
FIRESTORE_PORT=${FIRESTORE_PORT:-9180}
FUNCTIONS_PORT=${FUNCTIONS_PORT:-5001}
STORAGE_PORT=${STORAGE_PORT:-9199}

echo "Launching Flutter with emulator configuration:"
echo "  IP:         $IP"
echo "  Auth:       $AUTH_PORT"
echo "  Firestore:  $FIRESTORE_PORT"
echo "  Functions:  $FUNCTIONS_PORT"
echo "  Storage:    $STORAGE_PORT"
echo ""

cd "$PROJECT_ROOT"

flutter run \
  --dart-define=env=emulators \
  --dart-define=ip="$IP" \
  --dart-define=authPort="$AUTH_PORT" \
  --dart-define=firestorePort="$FIRESTORE_PORT" \
  --dart-define=functionsPort="$FUNCTIONS_PORT" \
  --dart-define=storagePort="$STORAGE_PORT" \
  "$@"

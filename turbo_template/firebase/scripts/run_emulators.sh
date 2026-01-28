#!/bin/bash

# Get the absolute path to the firebase directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
FIREBASE_DIR="$( cd "$SCRIPT_DIR/.." &> /dev/null && pwd )"
FUNCTIONS_DIR="$FIREBASE_DIR/functions"

# Function to check if a port is available
is_port_available() {
    local port=$1
    ! lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1
}

cleanup() {
    if [ -n "${WATCH_PID:-}" ]; then
        kill "$WATCH_PID" 2>/dev/null || true
    fi
    # Clean up temp firebase config files (both specific and any stale ones)
    if [ -n "${TMP_FIREBASE_JSON:-}" ] && [ -f "$TMP_FIREBASE_JSON" ]; then
        rm -f "$TMP_FIREBASE_JSON" || true
    fi
    rm -f "$FIREBASE_DIR"/firebase.emulators.*.json 2>/dev/null || true
}

trap cleanup EXIT

DEFAULT_PORT_BASE=9200
BLOCK_SIZE=10
PORT_BASE=${PORT_BASE:-$DEFAULT_PORT_BASE}

AUTH_PORT=$((PORT_BASE + 0))
FIRESTORE_PORT=$((PORT_BASE + 1))
FUNCTIONS_PORT=$((PORT_BASE + 2))
STORAGE_PORT=$((PORT_BASE + 3))
HUB_PORT=$((PORT_BASE + 4))
UI_PORT=$((PORT_BASE + 5))

set_ports_from_base() {
    local base=$1

    AUTH_PORT=$((base + 0))
    FIRESTORE_PORT=$((base + 1))
    FUNCTIONS_PORT=$((base + 2))
    STORAGE_PORT=$((base + 3))
    HUB_PORT=$((base + 4))
    UI_PORT=$((base + 5))
}

are_ports_free() {
    is_port_available "$AUTH_PORT" && \
    is_port_available "$FIRESTORE_PORT" && \
    is_port_available "$FUNCTIONS_PORT" && \
    is_port_available "$STORAGE_PORT" && \
    is_port_available "$HUB_PORT" && \
    is_port_available "$UI_PORT"
}

kill_firebase_on_ports() {
    lsof -t -i:"$AUTH_PORT" -i:"$FUNCTIONS_PORT" -i:"$FIRESTORE_PORT" -i:"$STORAGE_PORT" -i:"$HUB_PORT" -i:"$UI_PORT" 2>/dev/null | sort -u | while read -r pid; do
        if ps -p "$pid" -o command | grep -q "firebase"; then
            kill -TERM "$pid" 2>/dev/null || true
        fi
    done
}

echo "Selecting emulator port base..."
while true; do
    set_ports_from_base "$PORT_BASE"

    echo "Trying PORT_BASE=$PORT_BASE (Auth:$AUTH_PORT Firestore:$FIRESTORE_PORT Functions:$FUNCTIONS_PORT Storage:$STORAGE_PORT Hub:$HUB_PORT UI:$UI_PORT)"

    echo "Stopping firebase emulators for this project..."
    kill_firebase_on_ports
    sleep 2

    if are_ports_free; then
        break
    fi

    PORT_BASE=$((PORT_BASE + BLOCK_SIZE))
    if [ "$PORT_BASE" -gt 65529 ]; then
        echo "Error: No available port base found." >&2
        exit 1
    fi
done

# Navigate to functions directory and do initial clean build
cd "$FUNCTIONS_DIR" || exit
rm -rf lib/
npm run build

# Start TypeScript compiler in watch mode in background
npm run build:watch &
WATCH_PID=$!

cd "$FIREBASE_DIR" || exit

echo "Checking port availability..."

if ! are_ports_free; then
    echo "Error: Ports are still in use after shutdown for PORT_BASE=$PORT_BASE." >&2
    echo "  Auth: $AUTH_PORT" >&2
    echo "  Firestore: $FIRESTORE_PORT" >&2
    echo "  Functions: $FUNCTIONS_PORT" >&2
    echo "  Storage: $STORAGE_PORT" >&2
    echo "  Hub: $HUB_PORT" >&2
    echo "  UI: $UI_PORT" >&2
    exit 1
fi

echo "Configuring emulators..."

# Clean up any stale temp firebase config files
rm -f "$FIREBASE_DIR"/firebase.emulators.*.json 2>/dev/null || true

TMP_FIREBASE_JSON="$(mktemp "$FIREBASE_DIR/firebase.emulators.XXXXXX.json")"

# Verify temp file was created
if [ -z "$TMP_FIREBASE_JSON" ] || [ ! -f "$TMP_FIREBASE_JSON" ]; then
    echo "Error: Failed to create temporary firebase config file." >&2
    exit 1
fi

jq --arg auth_port "$AUTH_PORT" \
   --arg functions_port "$FUNCTIONS_PORT" \
   --arg firestore_port "$FIRESTORE_PORT" \
   --arg storage_port "$STORAGE_PORT" \
   --arg hub_port "$HUB_PORT" \
   --arg ui_port "$UI_PORT" \
   '.emulators.auth.port = ($auth_port | tonumber) |
    .emulators.auth.options = {"projectId": "demo-project", "allowDuplicateEmails": true, "anonymousEnabled": true} |
    .emulators.functions.port = ($functions_port | tonumber) |
    .emulators.firestore.port = ($firestore_port | tonumber) |
    .emulators.storage.port = ($storage_port | tonumber) |
    .emulators.hub.port = ($hub_port | tonumber) |
    .emulators.ui.port = ($ui_port | tonumber)' "$FIREBASE_DIR/firebase.json" > "$TMP_FIREBASE_JSON"

echo "Emulators configured:"
echo "  Auth: $AUTH_PORT"
echo "  Functions: $FUNCTIONS_PORT"
echo "  Firestore: $FIRESTORE_PORT"
echo "  Storage: $STORAGE_PORT"
echo "  Hub: $HUB_PORT"
echo "  UI: $UI_PORT"

# Get the machine's IP address for connecting from mobile devices
IP_ADDRESS=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | head -n 1 | awk '{print $2}')
echo "Your machine's IP address for mobile connections: $IP_ADDRESS"
echo "Use this IP in your Flutter app with: flutter run --dart-define=ip=$IP_ADDRESS --dart-define=env=emulators --dart-define=AUTH_PORT=$AUTH_PORT --dart-define=FIRESTORE_PORT=$FIRESTORE_PORT --dart-define=FUNCTIONS_PORT=$FUNCTIONS_PORT --dart-define=STORAGE_PORT=$STORAGE_PORT"

# Update IntelliJ run configuration with current IP and ports
PROJECT_DIR="$( cd "$FIREBASE_DIR/.." &> /dev/null && pwd )"
RUN_CONFIG="$PROJECT_DIR/.run/Run Emulators.run.xml"
NEW_ARGS="--dart-define=env=emulators --dart-define=ip=$IP_ADDRESS --dart-define=AUTH_PORT=$AUTH_PORT --dart-define=FIRESTORE_PORT=$FIRESTORE_PORT --dart-define=FUNCTIONS_PORT=$FUNCTIONS_PORT --dart-define=STORAGE_PORT=$STORAGE_PORT --flavor prod"
if [ -f "$RUN_CONFIG" ]; then
    sed -i '' "s|value=\"--dart-define=env=emulators[^\"]*\"|value=\"$NEW_ARGS\"|" "$RUN_CONFIG"
    echo "✅ Updated Run Emulators run configuration with IP: $IP_ADDRESS"
fi

# Update monorepo run configuration
MONOREPO_DIR="$( cd "$FIREBASE_DIR/../.." &> /dev/null && pwd )"
MONOREPO_RUN_CONFIG="$MONOREPO_DIR/.run/Turbo Template - Emulators.run.xml"
if [ -f "$MONOREPO_RUN_CONFIG" ]; then
    sed -i '' "s|value=\"--dart-define=env=emulators[^\"]*\"|value=\"$NEW_ARGS\"|" "$MONOREPO_RUN_CONFIG"
    echo "✅ Updated monorepo run configuration with IP: $IP_ADDRESS"
fi

if [ -d "exports/firestore_export" ] || [ -f "exports/auth_export.json" ]; then
    echo "Starting emulators with data import..."
    firebase emulators:start --config "$TMP_FIREBASE_JSON" --import=exports --export-on-exit=exports
else
    echo "No exports found, starting clean emulators..."
    firebase emulators:start --config "$TMP_FIREBASE_JSON" --export-on-exit=exports &
    EMULATOR_PID=$!
    # Wait for auth emulator to be ready, then seed users
    echo "Waiting for Auth emulator to start..."
    until nc -z 127.0.0.1 $AUTH_PORT; do
      sleep 1
    done
    echo "Auth emulator is up. Seeding users..."
    export AUTH_PORT="$AUTH_PORT"
    dart "$PROJECT_DIR/flutter-app/scripts/seed_auth_users.dart" || true
    wait $EMULATOR_PID
fi

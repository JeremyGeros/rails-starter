#!/usr/bin/env bash

set -euo pipefail

PORT="${PORT:-8080}"
RAILS_ENV="${RAILS_ENV:-development}"
export PORT RAILS_ENV

bundle install
npm install

bin/rails db:migrate

echo "Starting processes (Rails, Vite, Tailwind) on port $PORT..."

terminate() {
	echo "Shutting down..."
	pkill -P $$ || true
	wait
}
trap terminate INT TERM

# Start Rails server
bin/rails server -p "$PORT" &
RAILS_PID=$!

# Start vite dev server
bin/vite dev &
VITE_PID=$!

# Start tailwind watcher if available (fall back to build if not)
if bin/rails list | grep -q tailwindcss:watch 2>/dev/null; then
	bin/rails tailwindcss:watch &
	TAILWIND_PID=$!
else
	echo "tailwindcss:watch task not found; running build once"
	if bin/rails list | grep -q tailwindcss:build 2>/dev/null; then
		bin/rails tailwindcss:build || true
	fi
fi

wait $RAILS_PID $VITE_PID ${TAILWIND_PID:-}

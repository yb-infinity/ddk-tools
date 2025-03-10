#!/bin/sh
set -e

echo "DrupalDevKit Tools"

# Log helper function
log() {
  if [ -n "${CI}" ]; then
    echo "$1"
  else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
  fi
}

# Check if BITBUCKET_CLONE_DIR is set and not empty
if [ -n "${BITBUCKET_CLONE_DIR}" ]; then
  if [ -d "${BITBUCKET_CLONE_DIR}" ]; then
    cd "${BITBUCKET_CLONE_DIR}" || exit 1
    log "Changed directory to ${BITBUCKET_CLONE_DIR}"
  fi
else
  cd /tmp || exit 1
  echo "Changed directory to /tmp"
fi

# Check if arguments were provided
if [ $# -eq 0 ]; then
  log "No command provided, running shell"
  exec /bin/sh
else
  log "Executing command: $@"
  # Execute the command passed to the docker container
  exec "$@"
fi

#!/bin/sh

# Check if BITBUCKET_CLONE_DIR is set and not empty
if [ -n "${BITBUCKET_CLONE_DIR}" ]; then
  # Change to the directory
  cd "${BITBUCKET_CLONE_DIR}" || exit 1
  echo "Changed directory to ${BITBUCKET_CLONE_DIR}"
fi

# Execute the command passed to the docker container
exec "$@"

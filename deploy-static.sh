#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Working directory is set to "$DEPLOY_DIR"
# Available variables
# "$GL_USER" username of user doing this deploy (same as pubkey name)
# "$REV_OLD" full id of revision before deploy
# "$REV_NEW" full id of revision after deploy
# "$REF_NAME" full name of reference deployed to (eg. ref/heads/master)
# "$PROJECT_DIR" absolute path to project directory
# "$DEPLOY_DIR" absolute path to extracted stage

step "building assets"
mango install
mango build


step "swapping symlinks"
stage-live "$DEPLOY_DIR" "$PROJECT_DIR"

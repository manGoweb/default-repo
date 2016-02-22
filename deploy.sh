#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Available variables
# "$GL_USER" username of user doing this deploy (same as pubkey name)
# "$REV_OLD" full id of revision before deploy
# "$REV_NEW" full id of revision after deploy
# "$REF_NAME" full name of reference deployed to (eg. ref/heads/master)
# "$PROJECT_DIR" absolute path to project directory
# "$DEPLOY_DIR" absolute path to extracted stage

# For applications with mangoweb.blackbox
#echo "script: decrypting configuration"
#pushd "$DEPLOY_DIR"
#/opt/blackbox/bin/blackbox_postdeploy
#popd

# TODO custom builds etc

echo "script: swapping symlinks"
# creating a symlink is not an atomic operation, mv is atomic
# http://blog.moertel.com/posts/2005-08-22-how-to-change-symlinks-atomically.html
ln -s "$DEPLOY_DIR" "$PROJECT_DIR/live_stage" && mv -Tf "$PROJECT_DIR/live_stage" "$PROJECT_DIR/live"

echo "debug: script: reload php-fpm"
# reliably clears opcache
sudo /usr/bin/systemctl reload php70-php-fpm.service

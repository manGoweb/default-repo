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

function symlink-shared {
	if [[ ! -d "$PROJECT_DIR/$1" ]]; then
		mkdir -p "$PROJECT_DIR/$1"
		chmod ug+rwX,o= "$PROJECT_DIR/$1"
	fi
	rm -rf "$DEPLOY_DIR/$1" && ln -s "$PROJECT_DIR/$1" "$DEPLOY_DIR/$1"
}

# For applications with mangoweb.blackbox
#echo "script: decrypting configuration"
#pushd "$DEPLOY_DIR"
#/opt/blackbox/bin/blackbox_postdeploy
#popd

echo "script: creating local config"
cp "$DEPLOY_DIR/config/config.prod.neon" "$DEPLOY_DIR/config/config.local.neon"

echo "script: symlinking directories to persist between deploys"
symlink-shared "log"
symlink-shared "public/wp-content/uploads"
symlink-shared "public/wp-content/plugins"
symlink-shared "public/wp-content/themes"

echo "script: installing composer dependencies"
pushd "$DEPLOY_DIR"
composer install
popd

echo "script: building assets"
pushd "$DEPLOY_DIR"
mango install
mango build
popd

echo "script: swapping symlinks"
# creating a symlink is not an atomic operation, mv is atomic
# http://blog.moertel.com/posts/2005-08-22-how-to-change-symlinks-atomically.html
ln -s "$DEPLOY_DIR" "$PROJECT_DIR/live_stage" && mv -Tf "$PROJECT_DIR/live_stage" "$PROJECT_DIR/live"

echo "debug: script: reload php-fpm"
# reliably clears opcache
sudo /usr/bin/systemctl reload php70-php-fpm.service

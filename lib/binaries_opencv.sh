#!/usr/bin/env bash

title() {
  echo "-----> $*"
}

subtitle() {
  echo "       $*"
}

sed() { command sed -u "$@"; }
# SBL takes in BUILD_DIR CACHE_DIR ENV_DIR
install_opencv() {

	

	# Taken from python heroku buildpack
	###################################
	shopt -s extglob

	BUILD_DIR=$1
	CACHE_DIR=$2

	APP_DIR="/app"
	deep-cp $BUILD_DIR $APP_DIR
	ORIG_BUILD_DIR=$BUILD_DIR
	BUILD_DIR=$APP_DIR
	cd $BUILD_DIR

	unset LD_LIBRARY_PATH PATH PYTHONPATH

	export LD_LIBRARY_PATH="$BUILD_DIR/.heroku/vendor/lib/"
	export PATH="$HOME/usr/local/bin:$BUILD_DIR/.heroku/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
	export PYTHONPATH="$HOME/usr/local/lib:$BUILD_DIR/.heroku/vendor/lib/python2.7/site-packages/"

	# Setup environment
	# SBL cache dir is persisted between builds so this allows us to avoid re-fetching
	mkdir -p $CACHE_DIR
	title "Generating environment"
	if [ ! -f $CACHE_DIR/env.tar.gz ]; then
		subtitle "Fetching..."
		curl -s -L "https://github.com/psyntium/nodejs-opencv-buildpack/raw/master/lib/compiled-opencv.tgz" > $CACHE_DIR/env.tar.gz
	fi
	subtitle "Unpacking..."
	tar -xzf $CACHE_DIR/env.tar.gz -C $BUILD_DIR


	# installing application dependencies
	if [ -f $BUILD_DIR/requirements.txt ]; then
		title "Found requirements.txt, installing dependencies using pip"
		$BUILD_DIR/.heroku/vendor/bin/pip install -r requirements.txt --root=$HOME --exists-action=w --src=./.heroku/src --allow-all-external
	fi

	# creating env variables
	# TODO remove the below PATH if python is still having issues
	title "Creating environment variables."
	mkdir -p $BUILD_DIR/.profile.d
	echo 'export LD_LIBRARY_PATH="\$HOME/.heroku/vendor/lib/:\$HOME/.heroku/vendor/lib/:\$LD_LIBRARY_PATH"; ' > $BUILD_DIR/.profile.d/5251124.sh
	echo 'export PATH="\$HOME/usr/local/bin:\$HOME/.heroku/vendor/bin:\$PATH"; ' >> $BUILD_DIR/.profile.d/5251124.sh
	echo 'export PYTHONPATH="\$HOME/usr/local/lib/python2.7/site-packages/:\$HOME/.heroku/vendor/lib/:\$HOME/.heroku/vendor/lib/python2.7/site-packages/"; ' >> $BUILD_DIR/.profile.d/5251124.sh
	#cat $BUILD_DIR/.profile.d/5251124.sh
	# export "\$LIBRARY_PATH=\$HOME/.heroku/vendor/lib/:\$LIBRARY_PATH"
	# export "\$LD_LIBRARY_PATH=\$HOME/.heroku/vendor/lib/:\$LD_LIBRARY_PATH"
	# export "\$PATH=\$HOME/.heroku/vendor/lib/:\$PATH"
	# export "\$PYTHONPATH=\$HOME/.heroku/vendor/lib/:\$PYTHONPATH"
	# above lines didn't do anything

	deep-cp $BUILD_DIR $ORIG_BUILD_DIR

	title "Buildpack installed."
	
}

deep-cp() {
	echo "Deep Copying from " $1 " to " $2

	declare source="$1" target="$2"

	mkdir -p "$target"

	# cp doesn't like being called without source params,
	# so make sure they expand to something first.
	# subshell to avoid surprising caller with shopts.
	(
	shopt -s nullglob dotglob
	set -- "$source"/
	[[ $# == 0 ]] || cp -a "$@" "$target"
	)
}

# Does some serious deleting.
deep-rm() {
  # subshell to avoid surprising caller with shopts.
	(
		shopt -s dotglob
		rm -rf "$1"/
	)
}
###################################

# Does some serious moving.
deep-mv() {
	echo "Deep Moving from " $1 " to " $2
	deep-cp "$1" "$2"
	#deep-rm "$1"
}

#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

echo "current dir: $(pwd)"

if [ -z "$1" ]; then
    DEST=~
else
    DEST="$1"
fi

git pull origin master;

echo "Copying files from $(pwd) to ${DEST}"

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ${DEST};
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

#!/usr/bin/env bash
# Argument = -f -d destination


usage() {
    cat << EOF
usage: $0 options
This script will copy dotfiles to ~

OPTIONS:
-h Show this message
-f Force
-d Destination path

EOF
}

FORCE=0
DEST=~
while getopts "hfd:" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        f)
            FORCE=1
            ;;
        d)
            DEST=$OPTARG
            ;;
    esac
done

cd "$(dirname "${BASH_SOURCE}")";

echo "current dir: $(pwd)"

git pull origin master;

echo "Copying files from $(pwd) to ${DEST}"

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ${DEST};
	source ~/.bash_profile;
}

if [ "$FORCE" == 1 ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

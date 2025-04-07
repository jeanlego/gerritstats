#!/usr/bin/env bash

SERVER="$1"
OUTPUT_DIR="$2"

source $NVM_DIR/nvm.sh

/opt/gerritstats/gerrit_downloader.sh --server "$1" --output-dir "$2"
/opt/gerritstats/gerrit_stats.sh --files "$2"

cd "$2"
exec http-server -p 29420


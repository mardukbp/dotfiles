#!/bin/bash

REPOSITORY_URI=${1:?"Missing required URI"}
OUTPUT_DIRECTORY="/media/Archivos/Downloads/git"

cd "$OUTPUT_DIRECTORY" &&
git clone "$REPOSITORY_URI" &&
exit 0

#!/bin/bash

set -e

PUML_JAR_NAME=plantuml-nodot.1.2023.5.jar
PUML_DOWNLOAD_LINK=https://versaweb.dl.sourceforge.net/project/plantuml/1.2023.5

# Directory Vairables
PROJECT_DIR=$(pwd -P)
PUML_DIR="$PROJECT_DIR/artifacts/puml"
ARTIFACTS_DIR="$PROJECT_DIR/artifacts"
DOCS_DIR="$PROJECT_DIR/docs"
GEN_IMG_DIR="$DOCS_DIR/artifacts/images/"

# If the jar isn't downloaded, go ahead and download it.
if [ ! -f $PUML_JAR_NAME ]; then
    wget "$PUML_DOWNLOAD_LINK/$PUML_JAR_NAME"
fi

find "$PUML_DIR" -name "*.puml" -exec java -jar $PUML_JAR_NAME -tsvg -Playout=smetana -o "$ARTIFACTS_DIR" "{}" \;

# Create the generated images directory in the Gatsby directory
if [ -d "$GEN_IMG_DIR" ]; then
    rm -rf "$GEN_IMG_DIR"
fi
mkdir -p "$GEN_IMG_DIR"

# Move the artifacts to the Gatsby Images Directory
find "$(pwd -P)/artifacts" -name "*.svg" -exec cp {} "$GEN_IMG_DIR/" \;
find "$GEN_IMG_DIR/" -name "*.svg" -exec sh -c 'NEW_FILE=$(echo "{}" | tr -d " "); mv "{}" "$NEW_FILE"' \; # Temp line until we fix the issue with spaces in puml diagram output filenames

#!/bin/bash

# Get the current values of main and types
main=$(jq -r '.main' package.json)
types=$(jq -r '.types' package.json)

# Define the new values for prepublish and postpublish
prepublish_main="./dist/index.js"
prepublish_types="./dist/index.d.ts"
postpublish_main="index.ts"
postpublish_types="index.ts"

# Check if the script is run as prepublish or postpublish
if [ "$npm_lifecycle_event" == "prepublish" ]; then
  # Update the package.json with the new values for prepublish
  jq --arg main "$prepublish_main" --arg types "$prepublish_types" \
    '.main = $main | .types = $types' package.json > tmp.json && mv tmp.json package.json
elif [ "$npm_lifecycle_event" == "postpublish" ]; then
  # Update the package.json with the new values for postpublish
  jq --arg main "$postpublish_main" --arg types "$postpublish_types" \
    '.main = $main | .types = $types' package.json > tmp.json && mv tmp.json package.json
else
  # Exit with an error message if neither prepublish nor postpublish
  echo "This script should only be run as prepublish or postpublish."
  exit 1
fi
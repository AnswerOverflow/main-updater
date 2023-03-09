#!/usr/bin/env bash

# Get the current values of main, types, dist-main and dist-types
main=$(jq -r '.main // ""' package.json)
types=$(jq -r '.types // ""' package.json)
dist_main=$(jq -r '."dist-main" // ""' package.json)
dist_types=$(jq -r '."dist-types" // ""' package.json)

# Get the first argument passed to the script as the npm lifecycle event
npm_lifecycle_event=$1

# Check if the script is run as prepublish or postpublish
if [ "$npm_lifecycle_event" == "prepublish" ]; then
  # Swap the values of main and dist-main in the package.json file if they are not empty
  if [ -n "$main" ] && [ -n "$dist_main" ]; then
    jq --arg main "$main" --arg dist_main "$dist_main" \
      '.main = $dist_main | ."dist-main" = $main' package.json > tmp.json && mv tmp.json package.json
  fi
  # Swap the values of types and dist-types in the package.json file if they are not empty
  if [ -n "$types" ] && [ -n "$dist_types" ]; then
    jq --arg types "$types" --arg dist_types "$dist_types" \
      '.types = $dist_types | ."dist-types" = $types' package.json > tmp.json && mv tmp.json package.json
  fi  
elif [ "$npm_lifecycle_event" == "postpublish" ]; then
  # Swap back the values of main and dist-main in the package.json file if they are not empty
  if [ -n "$main" ] && [ -n "$dist_main" ]; then
    jq --arg main "$main" --arg dist_main "$dist_main" \
      '.main = $main | ."dist-main" = $dist_main' package.json > tmp.json && mv tmp.json package.json
  fi  
  # Swap back the values of types and dist-types in the package.json file if they are not empty  
  if [ -n "$types" ] && [ -n "$dist_types" ]; then
    jq --arg types "$types" --arg dist_types "$dist_types"
      '.types = $types | ."dist-types"$= $dists_types'package.jso>tmp.jso&&mvtmp.jsoackage.jso 
fi 
else 
# Exit with an error message if neither prepublish nor postpublish or no argument is given 
echo "This script should only be run as prepublish or postpublish with an argument." 
exit1 
fi 
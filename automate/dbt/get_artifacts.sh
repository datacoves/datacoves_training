#! /bin/bash

# Cause script to exit on error
set -e

cd $DATACOVES__DBT_HOME

mkdir -p logs

dbt run-operation get_last_artifacts

# Check if manifest,son exist, count lines if does or set to 0
if [ -e "logs/manifest.json" ]; then
LINES_IN_MANIFEST="$(grep -c '^' logs/manifest.json)"
else
    LINES_IN_MANIFEST="0"
fi

if [ $LINES_IN_MANIFEST -eq 0 ]
then
    echo "Manifest not found in Snowflake stage, contact the Snowflake administrator to load a updated manifest to snowflake."
    # This is used by github actions
    echo "::set-output name=manifest_found::false"

    # This is used by Jenkins
    # echo "false" > temp_MANIFEST_FOUND.txt
else
    echo "Updated manifest from production"

    # This is used by github actions
    echo "::set-output name=manifest_found::true"

    # This is used by Jenkins
    # echo "true" > temp_MANIFEST_FOUND.txt
fi

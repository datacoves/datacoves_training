#! /bin/bash
set -e
cd "$DATACOVES__DBT_HOME"
git fetch --tags
date_version=$(date -u +%Y%m%d)
# Version scheme: YYYYMMDD.N.0, N = next unused sequence number for today.
last_sequence=$(
  git tag --list "${date_version}.*" |
  sed -E "s/^${date_version}\.([0-9]+)\..*/\1/" |
  grep -E '^[0-9]+$' | sort -n | tail -1
)
if [ -z "$last_sequence" ]; then next_sequence=1; else next_sequence=$((last_sequence + 1)); fi
new_version="${date_version}.${next_sequence}.0"
# Anchored to line start so it only matches `version:`, not `config-version:`.
sed -i "s/^version:.*/version: '${new_version}'/g" dbt_project.yml
git add dbt_project.yml
# [skip ci] prevents this commit from retriggering push-to-main.yml.
git commit -m "Set deployment version to ${new_version} [skip ci]"
git tag -m "[skip ci]" "${new_version}"

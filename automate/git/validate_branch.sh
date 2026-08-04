#!/bin/bash
set -e

SOURCE_BRANCH="${1#refs/heads/}"
TARGET_BRANCH="${2#refs/heads/}"

if [ "$SOURCE_BRANCH" = "$TARGET_BRANCH" ]; then
  echo "Source and target branch are the same ($SOURCE_BRANCH); skipping branch validation."
  exit 0
fi

if [[ "$SOURCE_BRANCH" != feature/* && "$SOURCE_BRANCH" != infra/* ]]; then
  echo "ERROR: Source branch '$SOURCE_BRANCH' must start with 'feature/' or 'infra/'."
  exit 1
fi

if [ "$TARGET_BRANCH" != "main" ]; then
  echo "ERROR: Target branch must be 'main', got '$TARGET_BRANCH'."
  exit 1
fi

git fetch origin main
commits_behind=$(git rev-list --count HEAD..origin/main)
if [ "$commits_behind" -gt 0 ]; then
  echo "ERROR: Branch '$SOURCE_BRANCH' is $commits_behind commit(s) behind 'main'. Please merge/pull main into your branch and push again."
  exit 1
fi

if [[ "$SOURCE_BRANCH" == infra/* ]]; then
  changed_transform_files=$(git diff --name-only origin/main HEAD -- transform/)
  if [ -n "$changed_transform_files" ]; then
    echo "ERROR: infra/ branches cannot modify transform/. dbt model changes must use a feature/ branch."
    echo "$changed_transform_files"
    exit 1
  fi
fi

echo "Branch validation passed: '$SOURCE_BRANCH' -> '$TARGET_BRANCH'."

#!/usr/bin/env bash
#
# Interactive helper for publishing `wire` to pub.dev.
#
# It validates the repo, runs the standard checks, shows the version that
# would be published, then asks before each action. The actual upload is done
# by `dart pub publish`, which handles pub.dev OAuth and its own confirmation.
#
# Usage: ./publish.sh
#

set -euo pipefail

cd "$(dirname "$0")"

DART="${DART:-dart}"
REMOTE="${REMOTE:-origin}"
BRANCH="${BRANCH:-master}"
PACKAGE="wire"

ask_yes() {
  local answer
  read -r -p "$1 [Y/n] " answer
  [[ -z "$answer" || "$answer" =~ ^[Yy]$ ]]
}

ask_no() {
  local answer
  read -r -p "$1 [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

step() {
  printf '\n==> %s\n' "$1"
}

# ---------------------------------------------------------------------------
# Preconditions — these are not optional.
# ---------------------------------------------------------------------------
step "Checking repository state"

current_branch="$(git branch --show-current)"
[[ "$current_branch" == "$BRANCH" ]] ||
  fail "switch to '$BRANCH' before publishing (currently '$current_branch')."

[[ -z "$(git status --porcelain)" ]] ||
  fail "working tree is not clean. Commit or stash changes first."

git fetch "$REMOTE"
git merge --ff-only "$REMOTE/$BRANCH" >/dev/null

VERSION="$(grep -E '^version:' pubspec.yaml | awk '{print $2}' | tr -d '\"'\''')"
[[ -n "$VERSION" ]] || fail "could not read version from pubspec.yaml"

PUB_LATEST="$(curl -fsSL "https://pub.dev/api/packages/$PACKAGE" |
  python3 -c 'import json,sys; print(json.load(sys.stdin)["latest"]["version"])' 2>/dev/null || true)"

printf 'Package:        %s\n' "$PACKAGE"
printf 'Local version:  %s\n' "$VERSION"
printf 'pub.dev latest: %s\n' "${PUB_LATEST:-unknown}"

if [[ -n "$PUB_LATEST" && "$VERSION" == "$PUB_LATEST" ]]; then
  fail "$VERSION is already published; bump the version in pubspec.yaml first."
fi

grep -q "^## Version $VERSION" CHANGELOG.md ||
  printf 'WARNING: no "## Version %s" entry found in CHANGELOG.md\n' "$VERSION"

# ---------------------------------------------------------------------------
# Standard checks — prompted, but required before publishing.
# ---------------------------------------------------------------------------
step "Preflight checks"

if ask_yes "Run '$DART pub get'?"; then
  "$DART" pub get
else
  fail "pub get is required before publishing."
fi

if ask_yes "Run '$DART analyze'?"; then
  "$DART" analyze || fail "analyzer reported issues."
else
  fail "analyzer check is required before publishing."
fi

if ask_yes "Run '$DART test'?"; then
  "$DART" test || fail "tests failed."
else
  fail "tests are required before publishing."
fi

if ask_yes "Run '$DART pub publish --dry-run'?"; then
  "$DART" pub publish --dry-run || fail "dry run failed."
else
  fail "dry run is required before publishing."
fi

# ---------------------------------------------------------------------------
# Publish.
# ---------------------------------------------------------------------------
step "Publishing"

if ask_no "Publish $PACKAGE $VERSION to pub.dev now?"; then
  "$DART" pub publish
else
  printf 'Publish skipped.\n'
  exit 0
fi

# ---------------------------------------------------------------------------
# Tag the published version.
# ---------------------------------------------------------------------------
step "Tagging release"

if ask_yes "Create and push tag v$VERSION?"; then
  git tag "v$VERSION"
  git push "$REMOTE" "v$VERSION"
  printf 'Tagged and pushed v%s.\n' "$VERSION"
else
  printf 'Tag skipped. You can add it later with: git tag v%s && git push %s v%s\n' \
    "$VERSION" "$REMOTE" "$VERSION"
fi

printf '\nDone. Verify at https://pub.dev/packages/%s/versions/%s\n' "$PACKAGE" "$VERSION"

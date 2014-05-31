#!/bin/bash

sourcecontains() {
  dirs=$(ls -d */ | grep -v "^dist/")
  files=$(find $dirs -name "*.hs")
  grep -i "$@" $files
}

if [ $UNSAFECOMMIT ]; then
  exit 0
fi

if ! $IGNOREDEPS; then
  if ! cabal sandbox list-sources | grep "references to local build trees" > /dev/null; then
    echo "cabal sandbox has sources:"
    cabal sandbox list-sources | head -n-2 | tail -n-3
    exit 1;
  fi
fi

git stash --keep-index --include-untracked &&

if $CHECKDONOTSUBMIT && sourcecontains "do not submit"; then
  echo
  echo Found instances of \"do not submit\"
  git stash pop
  exit 1
fi &&

setup.sh &&
build.sh &&
test.sh &&
echo
RET=$?

git stash pop
exit $RET

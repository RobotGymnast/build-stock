#!/bin/bash

if [ $# -eq 0 ]; then
  NAME=`pwd | rev | cut -d "/" -f1 | rev`
else
  NAME=$1 &&
  shift 1 &&
  mkdir "$NAME" &&
  cd "$NAME"
fi &&

stockdir=$(echo $0 | sed "s/\/[^/]*$//")
ln "$stockdir/.gitignore" &&
ln "$stockdir/.travis.yml" &&
cp "$stockdir/.cabal" "$NAME.cabal" &&
git init &&
cp "$stockdir/pre-commit.sh" .git/hooks/pre-commit &&
cabal sandbox init &&
$EDITOR "$NAME.cabal"

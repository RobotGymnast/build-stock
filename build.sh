#!/bin/bash

tmp=$(mktemp)
show=60

filter="^\(Loading package\|You are using a new version of LLVM that hasn't been tested yet!$\|We will try though...$\)"
cabal build $@ |
stdbuf -oL -eL grep -v "$filter" |
tee $tmp |
head -$show

ret=${PIPESTATUS[0]}

lines=$(wc -l $tmp | cut -d " " -f1)
remain=$[$lines - $show]
if [ $remain -gt 0 ]; then
  echo
  echo \($remain lines hidden\)
fi

exit $ret

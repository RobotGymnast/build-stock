#!/bin/bash

cabal sandbox list-sources >/dev/null &&
cabal install --only-dependencies --enable-tests &&
cabal configure --enable-tests $@

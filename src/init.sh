#!/bin/sh
KAMION_REPO="https://github.com/Denocord/kamion.git"
git clone $KAMION_REPO kamion

export KAMION_BASE="$PWD/kamion"

. $KAMION_BASE/check.sh
#!/bin/sh
# all the available LGG releases can be found at  /cvmfs/sft.cern.ch/lcg/releases/
#setup root for slc6 and gcc8
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt ROOT"
#setup fastjet
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt fastjet"
#setup lhapdf
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt lhapdf 6.2.3"
source ./../requirements/export.sh

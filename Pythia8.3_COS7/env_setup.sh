#!/bin/sh
# all the available LGG releases can be found at  /cvmfs/sft.cern.ch/lcg/releases/
setupATLAS
#setup root for centos7 and gcc8
lsetup "lcgenv -p LCG_98python3 x86_64-centos7-gcc8-opt ROOT"
#setup fastjet
lsetup "lcgenv -p LCG_98python3 x86_64-centos7-gcc8-opt fastjet"
#setup lhapdf
lsetup "lcgenv -p LCG_98python3 x86_64-centos7-gcc8-opt lhapdf"
source ./../requirements/export8.3_COS7.sh

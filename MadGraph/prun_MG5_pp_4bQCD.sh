#!/bin/sh

CERN_USER=tkar

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh

#setup root for slc6 and gcc8
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt ROOT"
#setup fastjet
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt fastjet"
#setup lhapdf
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt lhapdf 6.2.3"
export LHAPDF_DATA_PATH=/cvmfs/atlas.cern.ch/repo/sw/Generators/lhapdfsets/current:$LHAPDF_DATA_PATH
lsetup panda

rm tarball_pp_4bQCD.tar.gz
tar cvfz tarball_pp_4bQCD.tar.gz MG5_aMC_v2_6_6 run_MG5_pp_4bQCD.sh

prun --exec "run_MG5_pp_4bQCD.sh" --outDS user.${CERN_USER}.pp_4bQCD.v2 --outputs unweighted_events.lhe --inTarBall tarball_pp_4bQCD.tar.gz --nJobs 1000

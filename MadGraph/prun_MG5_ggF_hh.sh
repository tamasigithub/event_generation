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

rm tarball.tar.gz
tar cvfz tarball_ggF_hh.tar.gz MG5_aMC_v2_6_6 run_MG5_ggF_hh.sh

prun --exec "run_MG5_ggF_hh.sh" --outDS user.${CERN_USER}.pp_ggF_hh.v2 --outputs unweighted_events.lhe --inTarBall tarball_ggF_hh.tar.gz --nJobs 1000

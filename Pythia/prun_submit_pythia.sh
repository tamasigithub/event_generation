#!/bin/sh

CERN_USER=tkar

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh

# some random release, so that gcc and other software needed is fixed
#setup root for slc6 and gcc8
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt ROOT"
#setup fastjet
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt fastjet"
#setup lhapdf
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt lhapdf 6.2.3"
lsetup panda

rm tarball_pythia.tar.gz
tar cvfz tarball_pythia.tar.gz pythia8243 shower.cmnd run_it_pythia.sh

# for some reason this command sometimes doesn't work when executed using a bash script. 
# If that's the case just paste the line below in your terminal (of course replace $CERN_USER by your user name)
prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_hh.v2_unweighted_events.lhe/ --outDS user.${CERN_USER}.pp_ggF_hh_4b_pythia82_shower.v2 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1

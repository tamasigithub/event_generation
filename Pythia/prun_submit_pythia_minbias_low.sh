#!/bin/sh

CERN_USER=tkar

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh

# some random release, so that gcc and other software needed is fixed
lsetup asetup
lsetup panda
asetup here,AnalysisBase,21.2.64

rm tarball_pythia_minbias.tar.gz
tar cvfz tarball_pythia_minbias.tar.gz pythia8240 run_it_pythia_minbias.sh 

prun --exec "run_it_pythia_minbias.sh low" --outDS user.${CERN_USER}.minbias_low_pythia82_shower.v1 --outputs output.root --inTarBall tarball_pythia_minbias.tar.gz --nJobs 1


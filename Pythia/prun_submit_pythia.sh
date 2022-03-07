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

#### for some reason this command sometimes doesn't work when executed using a bash script. 
#### If that's the case just paste the line below in your terminal (of course replace $CERN_USER by your user name)
####prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_VBFC325_hh_NoGenCuts.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp_VBFC325_hh_4b_NoGenCuts_pythia82_shower.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr1.0hh.v2_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr1.0hh_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr2.0hh.v2_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr2.0hh_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr2.5hh.v2_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr2.5hh_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr3.0hh.v3_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr3.0hh_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr0.0hh.v3_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr0.0hh_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr-1.0hh.v3_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr-1.0hh_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr-2.0hh.v3_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr-2.0hh_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_ggF_Ctr1.5hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp_ggF_Ctr1.5hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
###prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp_4bQCD.v2_unweighted_events.lhe --outDS user.${CERN_USER}.pp_4bQCD_pythia82_GenCuts.v5 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1

#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_ggF_Ctr1.0hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_ggF_Ctr1.0hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_ggF_Ctr2.0hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_ggF_Ctr2.0hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_ggF_Ctr2.5hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_ggF_Ctr2.5hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_ggF_Ctr3.0hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_ggF_Ctr3.0hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_ggF_Ctr0.0hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_ggF_Ctr0.0hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_ggF_Ctr-1.0hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_ggF_Ctr-1.0hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_ggF_Ctr-2.0hh.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_ggF_Ctr-2.0hh_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1
#prun --exec "run_it_pythia.sh %IN" --inDS user.${CERN_USER}.pp14TeV_4bQCD.v1_unweighted_events.lhe --outDS user.${CERN_USER}.pp14TeV_4bQCD_pythia82_GenCuts.v1 --outputs output.root --inTarBall tarball_pythia.tar.gz --nFilesPerJob 1

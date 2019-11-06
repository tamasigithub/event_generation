#!/bin/sh
export DISPLAY=
## This script writes the MG5 commands into a file my_pp_4bMG5cmnd on the flight and
## is executed by providing it as the first argument to the MadGraph executable
## to produce lhe files for higgs pair production via Vector Boson Fusion(VBF)

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh

#setup root for slc6 and gcc8
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt ROOT"
#setup fastjet
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt fastjet"
#setup lhapdf
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt lhapdf 6.2.3"

#### IMPORTANT WHEN RUNNING MADGRAPH
export LHAPDF_DATA_PATH=/cvmfs/atlas.cern.ch/repo/sw/Generators/lhapdfsets/current:$LHAPDF_DATA_PATH

DIR=$PWD
export DIR=$PWD
export MG5_DIR=$DIR/MG5_aMC_v2_6_6
export HEP_LIB=$MG5_DIR/HEPTools/lib
export OUT_DIR=$DIR/data/pp_4b_proc
#export LHAPDF_DATA_PATH=$DIR:$LHAPDF_DATA_PATH

# create a random number as a seed
R=`shuf -i 1-10000000 -n 1`
if [ "x$R" == "x" ]
then
  R=$RANDOM
fi
echo "Random seed:, $R"

cd $MG5_DIR/bin
## write the MG5 commands into a file my_pp_4bMG5cmnd
####echo "import loop_sm_hh">>my_pp_4bMG5cmnd #this model has a parameter kl that can be modified for trilinear higgs coupling.
echo "# import a model that allows loop diagrams">my_pp_4bMG5cmnd
echo "define p = g u c d s u~ c~ d~ s~">>my_pp_4bMG5cmnd
echo "define j = g u c d s u~ c~ d~ s~">>my_pp_4bMG5cmnd
echo "generate p p > b b~ b b~ ">>my_pp_4bMG5cmnd
echo "output $OUT_DIR">>my_pp_4bMG5cmnd
echo "set automatic_html_opening False">>my_pp_4bMG5cmnd
echo "set collier $HEP_LIB">>my_pp_4bMG5cmnd
echo "set ninja $HEP_LIB">>my_pp_4bMG5cmnd
echo "launch $OUT_DIR">>my_pp_4bMG5cmnd
echo "set ebeam1 50000">>my_pp_4bMG5cmnd
echo "set ebeam2 50000">>my_pp_4bMG5cmnd
echo "set nevents 100000">>my_pp_4bMG5cmnd
echo "set dynamical_scale_choice 3">>my_pp_4bMG5cmnd
echo "set iseed $R">>my_pp_4bMG5cmnd
echo "set pdlabel lhapdf">>my_pp_4bMG5cmnd
echo "set lhaid 260400">>my_pp_4bMG5cmnd
echo "set ptj 20">>my_pp_4bMG5cmnd
echo "set ptb 20">>my_pp_4bMG5cmnd
echo "set etaj 3.0">>my_pp_4bMG5cmnd
echo "set etab 3.0">>my_pp_4bMG5cmnd
echo "set drjj 0.1">>my_pp_4bMG5cmnd
echo "set drbb 0.1">>my_pp_4bMG5cmnd
echo "set drbj 0.1">>my_pp_4bMG5cmnd
echo "launch $OUT_DIR -i ">>my_pp_4bMG5cmnd
echo "print_results --path=$OUT_DIR/cross_section_top.txt --format=short">>my_pp_4bMG5cmnd

echo "list MG5 directory: $MG5_DIR/bin"
ls $MG5_DIR/bin
## execute the Madgraph executable
./mg5_aMC my_pp_4bMG5cmnd

cd $DIR
cp $OUT_DIR/Events/run_01/unweighted_events.lhe.gz .

echo "list current directory: $DIR"
ls $DIR
# remove the existing lhe file, if any
rm unweighted_events.lhe
gunzip unweighted_events.lhe.gz
echo "DONE!"

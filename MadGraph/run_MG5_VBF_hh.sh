#!/bin/sh
export DISPLAY=
## This script writes the MG5 commands into a file myMG5cmnd on the flight and
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
export OUT_DIR=$DIR/data/vbf_hh_proc

# create a random number as a seed
R=`shuf -i 1-10000000 -n 1`
if [ "x$R" == "x" ]
then
  R=$RANDOM
fi
echo "Random seed:, $R"

cd $MG5_DIR/bin
## write the MG5 commands into a file myMG5cmnd
echo "# import a model that allows modification of coupling constants from CVMFS(should work both on lxplus and naf)">myMG5cmnd
echo "import model /cvmfs/atlas.cern.ch/repo/sw/Generators/madgraph/models/latest/HHVBF_UFO-vbf_hh">>myMG5cmnd
echo "# redefine the protons and the jets so as to use four flavour scheme">>myMG5cmnd
echo "define p = g u c d s u~ c~ d~ s~">>myMG5cmnd
echo "define j = g u c d s u~ c~ d~ s~">>myMG5cmnd
echo "generate p p > h h j j QCD=0">>myMG5cmnd
echo "output $OUT_DIR">>myMG5cmnd
echo "set automatic_html_opening False">>myMG5cmnd
echo "launch $OUT_DIR">>myMG5cmnd
echo "set CV 1.0">>myMG5cmnd
echo "set C2V 1.0">>myMG5cmnd
echo "set C3 1.0">>myMG5cmnd
echo "set ebeam1 50000">>myMG5cmnd
echo "set ebeam2 50000">>myMG5cmnd
echo "set nevents 1000000">>myMG5cmnd
echo "set iseed $R">>myMG5cmnd
echo "set pdlabel nn23lo1">>myMG5cmnd
echo "set lhaid 230000">>myMG5cmnd
echo "#set cut_decays True #check whether to add this or not">>myMG5cmnd
echo "## most of the cuts can be applied later during or after simulation">>myMG5cmnd
echo "#set ptj 25.0">>myMG5cmnd
echo "#set ptb 25.0">>myMG5cmnd
echo "#set etaj 10.0">>myMG5cmnd
echo "#set etab 6.0">>myMG5cmnd
echo "#set drjj 4.0">>myMG5cmnd
echo "#set drbb 0.1">>myMG5cmnd
echo "#set drbj 0.4">>myMG5cmnd
echo "#set mmjj 600.0">>myMG5cmnd
echo "launch $OUT_DIR -i ">>myMG5cmnd
echo "print_results --path=$OUT_DIR/cross_section_top.txt --format=short">>myMG5cmnd

echo "list MG5 directory: $MG5_DIR/bin"
ls $MG5_DIR/bin
## execute the Madgraph executable
./mg5_aMC myMG5cmnd

cd $DIR
cp $OUT_DIR/Events/run_01/unweighted_events.lhe.gz .

echo "list current directory: $DIR"
ls $DIR
# remove the existing lhe file, if any
rm unweighted_events.lhe
gunzip unweighted_events.lhe.gz
echo "DONE!"

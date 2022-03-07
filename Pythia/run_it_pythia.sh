#!/bin/sh
DIR=$PWD

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh
#setup root for slc6 and gcc8
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt ROOT"
#setup fastjet
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt fastjet"
#setup lhapdf
lsetup "lcgenv -p LCG_96 x86_64-slc6-gcc8-opt lhapdf 6.2.3"

export PYTHIA8DIR=$DIR/pythia8243
export LHAPDF_PATH=$(eval lhapdf-config --prefix)

# Set input file name in the pythia 8 configuration file
INPUTFILE=$1
INPUTLIST=`echo $INPUTFILE | sed s/,/\ /g `
INPUTLISTHERE=
for i in $INPUTLIST
do
  NEWFILE=`echo $i | awk '{n = split($1,A,"/"); print A[n]}'`
  INPUTLISTHERE="$INPUTLISTHERE $NEWFILE"
  xrdcopy $i .
done

echo "List of files to run over:"
echo $INPUTLISTHERE

# Concatenate all files in the same one
cat $INPUTLISTHERE >input.lhe

echo "Listing directory"
ls -lh

# Not really necessary, but just in case
cp shower.cmnd $PYTHIA8DIR/examples
cp shower_1.cc $PYTHIA8DIR/examples

# recompile
# should not be necessary, but there seem to be slightly different GCC versions available in the Grid
cd $PYTHIA8DIR
make clean
./configure --enable-shared -enable-64bit --prefix=$PWD/../pythia8243-install --with-lhapdf6=$LHAPDF_PATH
#--with-lhapdf6=/cvmfs/atlas.cern.ch/repo/sw/software/21.2/AnalysisBaseExternals/21.2.64/InstallArea/x86_64-slc6-gcc62-opt
make
cd examples
make clean
make shower_1 
cd ../../

export LHAPDF_DATA_PATH=/cvmfs/atlas.cern.ch/repo/sw/Generators/lhapdfsets/current:$LHAPDF_DATA_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PYTHIA8DIR/lib
export PYTHIA8DATA=$PYTHIA8DIR/share/Pythia8/xmldoc
export PATH=$PATH:$PYTHIA8DIR/bin
export PATH=$PATH:$PYTHIA8DIR

sed -i s/Beams\:LHEF\.\*/Beams\:LHEF=input.lhe/g shower.cmnd

R=`shuf -i 1-10000000 -n 1`
if [ "x$R" == "x" ]
then
  R=$RANDOM
fi

echo "Running Pythia8 now"
$PYTHIA8DIR/examples/shower_1 input.lhe output.root $R

echo "Listing final directory"
ls -lh

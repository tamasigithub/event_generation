#!/bin/sh
# pruvide the input lhe file as the first argument while running this script
DIR=$PWD
export PYTHIA8DIR=$DIR/pythia8243
INPUTFILE=$1

R=`shuf -i 1-10000000 -n 1`
if [ "x$R" == "x" ]
then
  R=$RANDOM
fi
cd $PYTHIA8DIR/examples
#cp $DIR/shower.cc .
cp $DIR/shower_1.cc .
cp $DIR/shower.cmnd .
make clean
#make shower 
make shower_1 
cd ../../
echo "Running Pythia8 now"
$PYTHIA8DIR/examples/shower_1 $INPUTFILE output.root $R

echo "Done!"

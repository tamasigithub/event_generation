# EVENT GENERATORS 

This repository contains install and run(locally and on Grid) instructions for the following event generators:

* MadGraph5: Simulation of fixed-order matrix element.
* Pythia8: Simulation of parton shower based on perturbative QCD.

### Installation 
To install the above softwares go to the requirements directory and execute the corresponding install scripts.

If you are making these installation on your local pc, make sure you have the prerequisites already installed.

#### Prerequisites 
Try installing the latest verion of the following

* Root6
* FastJet
* LHAPDF

#### How do I get set up?

* Clone the repository using https or ssh
```
git clone git@bitbucket.org:kartamasi16/event-generators.git
```
* Create your own local branch and start working on it
```
cd event-generators
git branch <name_of_your_branch>
git checkout <name_of_your_branch>
```
* Go to the requirements directory and install the generator of your interest. 
```
cd requirements
source install-<software_of_interest>
```
Note: Source the install script with the source command. If installing on a local pc change the LHAPDF_DATA_PATH in the install scripts

The above will make a local installation of the software of your interest in the corresponding directories


### HOW to RUN 
* MadGraph: Please read the [README](https://bitbucket.org/kartamasi16/event-generators/src/master/MadGraph/README.md) for MadGraph
* Pythia: Please read the [README](https://bitbucket.org/kartamasi16/event-generators/src/master/Pythia/README.md) for Pythia


### Contact 
Tamasi Kar, University of Heidelberg

*tamasi.kar@cern.ch*


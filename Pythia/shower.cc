// main05.cc is a part of the PYTHIA event generator.
// Copyright (C) 2018 Torbjorn Sjostrand.
// PYTHIA is licenced under the GNU GPL v2 or later, see COPYING for details.
// Please respect the MCnet Guidelines, see GUIDELINES for details.

// This is a simple test program.
// It studies jet production at the LHC, using SlowJet and CellJet.
// Note: the two finders are intended to construct approximately the same
// jet properties, but provides output in slightly different format,
// and have here not been optimized to show maximum possible agreement.

#include "Pythia8/Pythia.h"

#include <vector>
#include <string>

#include "TFile.h"
#include "TTree.h"

#include <sstream>
#include <cmath>

using namespace Pythia8;

int main(int argc, char **argv) {

  std::string inputFile = "input.lhe";
  //std::string configurationFile = "shower.cmnd";
  if (argc >= 2) {
    inputFile = argv[1];
    //configurationFile = argv[1];
  }
  std::string outputFile = "output.root";
  if (argc >= 3) {
    outputFile = argv[2];
  }
  int iseed = 0;
  if (argc >= 4) {
    iseed = std::atoi(argv[3]);
  }


  // Generator. LHC process and output selection. Initialization.
  Pythia pythia;
  std::string configurationFile = "shower.cmnd";
  pythia.readFile(configurationFile.c_str());
  // Number of events, generated and listed ones.
  int nEvent    = 100;
  //int nEvent      = pythia.settings.mode("Main:numberOfEvents");
  std::cout << "Output    " << outputFile << std::endl;
  std::cout << "Events    " << nEvent << std::endl;

  std::string input_command = "Beams:LHEF = ";
  input_command += inputFile;
  pythia.readString(input_command);
  pythia.readString("Random:setSeed = on");
  std::stringstream buf;
  buf << "Random:seed = " << iseed;
  pythia.readString(buf.str().c_str());

  pythia.init();

  TFile *f = new TFile(outputFile.c_str(), "recreate");
  f->cd();

  TTree *t = new TTree("CollectionTree", "");

  float weight = 0;
  float mergingWeight = 0;
  std::vector<float> *px = 0;
  std::vector<float> *py = 0;
  std::vector<float> *pz = 0;
  std::vector<float> *e = 0;
  std::vector<float> *mass = 0;
  std::vector<int> *status = 0;
  std::vector<int> *statusPythia = 0;
  std::vector<int> *pdgId = 0;
  std::vector<int> *barcode = 0;
  std::vector<float> *charge = 0;
  std::vector<float> *vx = 0;
  std::vector<float> *vy = 0;
  std::vector<float> *vz = 0;
  std::vector<float> *vt = 0;

  t->Branch("weight", &weight, "weight/F");
  t->Branch("mergingWeight", &mergingWeight, "mergingWeight/F");
  t->Branch("px", &px);
  t->Branch("py", &py);
  t->Branch("pz", &pz);
  t->Branch("e", &e);
  t->Branch("m", &mass);
  t->Branch("pdgId", &pdgId);
  t->Branch("barcode", &barcode);
  t->Branch("charge", &charge);
  t->Branch("status", &status);
  t->Branch("statusPythia", &statusPythia);
  t->Branch("vx", &vx);
  t->Branch("vy", &vy);
  t->Branch("vz", &vz);
  t->Branch("vt", &vt);

  // general quantities, for the whole file
  //float crossSection = 0;
  float sumWeights = 0;
  float generated = 0;
  float passedFilter = 0;
  TTree *tinfo = new TTree("Metadata", "");
  //tinfo->Branch("crossSectionInPb", &crossSection, "crossSectionInPb/F");
  tinfo->Branch("sumWeights", &sumWeights, "sumWeights/F");
  tinfo->Branch("generated", &generated, "generated/F");
  tinfo->Branch("passedFilter", &passedFilter, "passedFilter/F");

  // Begin event loop. Generate event. Skip if error.
  int iEvent = 0;
  while (iEvent < nEvent) {
    if (!pythia.next()) continue;

    //std::cout << "Trying to generate event " << iEvent << "/" << nEvent << std::endl;

    generated += weight;

    // event passed, so save it
    // clear all vectors of the TTree first
    weight = 0;
    mergingWeight = 0;
    px->clear();
    py->clear();
    pz->clear();
    e->clear();
    mass->clear();
    pdgId->clear();
    status->clear();
    statusPythia->clear();
    barcode->clear();
    charge->clear();
    vx->clear();
    vy->clear();
    vz->clear();
    vt->clear();

    // get weights
    mergingWeight = pythia.info.mergingWeight();
    weight = pythia.info.weight();
    
    // loop over particles, select them, and add them in the vectors
    for (int i = 0; i < pythia.event.size(); ++i) {
      // save final particles, the Heavy Higgs (pdg ID 35) and the SM Higgs
      bool toSave = (pythia.event[i].isFinal() || abs(pythia.event[i].statusHepMC()) == 4);
      toSave |= (abs(pythia.event[i].status()) == 12);
      toSave |= (abs(pythia.event[i].status()) == 21);
      toSave |= (abs(pythia.event[i].status()) == 22);
      toSave |= (abs(pythia.event[i].status()) == 23);
      //std::cout << "Particle " << i << ", id " << pythia.event[i].id() << ", status = " << pythia.event[i].status() << ", final? " << pythia.event[i].isFinal() << std::endl;
      //std::cout << "Save it: " << toSave << std::endl;
      if (toSave) {
        float tpx = pythia.event[i].px()*1e3;
        float tpy = pythia.event[i].py()*1e3;
        float tpz = pythia.event[i].pz()*1e3;
        float te = pythia.event[i].e()*1e3;
        float tpdgId = pythia.event[i].id();
        float tcharge = pythia.event[i].charge();
        // This is the Pythia 8 status, as described here: http://home.thep.lu.se/~torbjorn/pythia81html/ParticleProperties.html
        int tstatusPythia = pythia.event[i].status();
        int tstatus = pythia.event[i].statusHepMC();
        float tmass = pythia.event[i].m()*1e3;
        float tvx = pythia.event[i].xProd();
        float tvy = pythia.event[i].yProd();
        float tvz = pythia.event[i].zProd();
        float tvt = pythia.event[i].tProd();
        px->push_back(tpx);
        py->push_back(tpy);
        pz->push_back(tpz);
        e->push_back(te);
        pdgId->push_back(tpdgId);
        statusPythia->push_back(tstatusPythia);
        status->push_back(tstatus);
        mass->push_back(tmass);
        barcode->push_back(i);
        charge->push_back(tcharge);
        vx->push_back(tvx);
        vy->push_back(tvy);
        vz->push_back(tvz);
        vt->push_back(tvt);
      }
    }

    sumWeights += weight;

    // fill event in file
    t->Fill();
    passedFilter += weight;
    generated += weight;

    iEvent++;
  // End of event loop. Statistics. Histograms.
  }
  // Fill metadata tree to store cross section and sum of weights for normalisation
  // it will only have one Entry by design
  //crossSection = pythia.processLevel.sigmaMC(); // private -- can only access by looking at the output log
  tinfo->Fill();

  pythia.stat();

  f->Write();
  f->Close();

  // Done.
  return 0;
}

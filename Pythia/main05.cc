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

#include "fastjet/ClusterSequence.hh"

#include <vector>
#include <string>

#include "TFile.h"
#include "TTree.h"

#include <sstream>
#include <cmath>

using namespace fastjet;
using namespace Pythia8;

int main(int argc, char **argv) {

  // Common parameters for the two jet finders.
  double etaMax   = 999.;
  double R        = 0.6;

  double pTjetMin = 0.;
  double pTjetMax = 0.;
  std::string mode = "";
  if (argc >= 2) {
    mode = argv[1];
  }
  if (mode == "low") {
    pTjetMin = 0.;
    pTjetMax = 35.;
  } else if (mode == "high") {
    pTjetMin = 35.;
    pTjetMax = 100e3;
  }
  
  std::string outputFile = "output.root";
  if (argc >= 3) {
    outputFile = argv[2];
  }
  int iseed = 0;
  if (argc >= 4) {
    iseed = std::atoi(argv[3]);
  }

  // Number of events, generated and listed ones.
  int nEvent    = 1000;
  std::cout << "R         " << R << std::endl;
  std::cout << "Eta max   " << etaMax << std::endl;
  std::cout << "Mode      " << mode << std::endl;
  std::cout << "pTmin     " << pTjetMin << std::endl;
  std::cout << "pTmax     " << pTjetMax << std::endl;
  std::cout << "Output    " << outputFile << std::endl;
  std::cout << "Events    " << nEvent << std::endl;

  // Generator. LHC process and output selection. Initialization.
  Pythia pythia;
  pythia.readString("Main:timesAllowErrors = 500");


  pythia.readString("Beams:eCM = 100000.");

  pythia.readString("6:m0 = 172.5");
  pythia.readString("23:m0 = 91.1876");
  pythia.readString("23:mWidth = 2.4952");
  pythia.readString("24:m0 = 80.399");
  pythia.readString("24:mWidth = 2.085");
  pythia.readString("StandardModel:sin2thetaW = 0.23113");
  pythia.readString("StandardModel:sin2thetaWbar = 0.23146");
  pythia.readString("ParticleDecays:limitTau0 = on");
  pythia.readString("ParticleDecays:tau0Max = 10.0");

  pythia.readString("Tune:pp = 5");
  pythia.readString("SpaceShower:rapidityOrder = on");
  pythia.readString("SigmaProcess:alphaSvalue = 0.140");
  pythia.readString("SpaceShower:pT0Ref = 1.62");
  pythia.readString("SpaceShower:pTmaxFudge = 0.92");
  pythia.readString("SpaceShower:pTdampFudge = 1.14");
  pythia.readString("SpaceShower:alphaSvalue = 0.129");
  pythia.readString("TimeShower:alphaSvalue = 0.129");
  pythia.readString("BeamRemnants:primordialKThard = 1.82");
  pythia.readString("MultipartonInteractions:pT0Ref = 2.22");
  pythia.readString("MultipartonInteractions:alphaSvalue = 0.127");

  //pythia.readString("PDF:useLHAPDF = on");
  //pythia.readString("PDF:LHAPDFset = MSTW2008lo68cl.LHgrid");
  //pythia.readString("BeamRemnants:reconnectRange = 2.28");
  //
  //New Pythia8.2 interface http://home.thep.lu.se/Pythia/pythia82html/PDFSelection.html
  pythia.readString("PDF:pSet = LHAGrid1:MSTW2008lo68cl.LHgrid");
  // Pythia8.2 renamed BeamRemnants:reconnectRange thus (http://home.thep.lu.se/Pythia/pythia82html/UpdateHistory.html)
  pythia.readString("ColourReconnection:range = 2.28");

  pythia.readString("SoftQCD:nonDiffractive = on");
  pythia.readString("SoftQCD:singleDiffractive = on");
  pythia.readString("SoftQCD:doubleDiffractive = on");
  pythia.readString("Tune:pp = 5");
  pythia.readString("MultipartonInteractions:bProfile = 4");
  pythia.readString("MultipartonInteractions:a1 = 0.03");
  pythia.readString("MultipartonInteractions:pT0Ref = 1.90");
  pythia.readString("MultipartonInteractions:ecmPow = 0.30");
  pythia.readString("SpaceShower:rapidityOrder=0");

  pythia.readString("Beams:allowVertexSpread = on");
  pythia.readString("Beams:sigmaVertexX = 6.8e-3");
  pythia.readString("Beams:sigmaVertexY = 6.8e-3");
  pythia.readString("Beams:sigmaVertexZ = 57");

  pythia.readString("Random:setSeed = on");
  std::stringstream buf;
  buf << "Random:seed = " << iseed;
  pythia.readString(buf.str().c_str());

  pythia.init();

  JetDefinition jet_def(antikt_algorithm, R);

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
  float crossSection = 0;
  float sumWeights = 0;
  float generated = 0;
  float passedFilter = 0;
  TTree *tinfo = new TTree("Metadata", "");
  tinfo->Branch("crossSectionInPb", &crossSection, "crossSectionInPb/F");
  tinfo->Branch("sumWeights", &sumWeights, "sumWeights/F");
  tinfo->Branch("generated", &generated, "generated/F");
  tinfo->Branch("passedFilter", &passedFilter, "passedFilter/F");

  // Begin event loop. Generate event. Skip if error.
  int iEvent = 0;
  while (iEvent < nEvent) {
    if (!pythia.next()) continue;

    //std::cout << "Trying to generate event " << iEvent << "/" << nEvent << std::endl;

    generated += weight;

    std::vector<PseudoJet> particles;
    particles.reserve(pythia.event.size());
    //std::cout << "Event size:" << pythia.event.size() << std::endl;
    for (int i = 0; i < pythia.event.size(); ++i) {
      if (pythia.event[i].isFinal()) {
        //if (abs(pythia.event[i].id()) == 12 || abs(pythia.event[i].id()) == 14 || abs(pythia.event[i].id()) == 16) continue;
        particles.push_back(PseudoJet(pythia.event[i].px(),
                                      pythia.event[i].py(),
                                      pythia.event[i].pz(),
                                      pythia.event[i].e()));
      }
    }
    //std::cout << "Particles size:" << particles.size() << std::endl;

    ClusterSequence cs(particles, jet_def);
    std::vector<PseudoJet> jet = sorted_by_pt(cs.inclusive_jets());

    //std::cout << "Jet size:" << jet.size() << std::endl;
    if (jet.size() < 1) continue;
    //std::cout << "Leading jet pt: " << jet[0].perp() << std::endl;

    double pTleading = 0.0;
    for (auto &k : jet) {
      if (std::fabs(k.rap()) < etaMax && pTleading < k.perp()) {
        pTleading = k.perp();
      }
    }
    //std::cout << "Leading jet pt after eta cut: " << pTleading << std::endl;

    // filter event
    if (pTleading < pTjetMin || pTleading > pTjetMax) continue;

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
    mergingWeight = pythia.info.mergingWeight()*pythia.info.mergingWeightNLO();
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
  crossSection = pythia.info.sigmaGen()*1e9; // convert mb to pb
  tinfo->Fill();

  pythia.stat();

  f->Write();
  f->Close();

  // Done.
  return 0;
}

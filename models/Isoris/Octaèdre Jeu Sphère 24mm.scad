// Octaèdre Jeu sphère 24mm

// changelog
// v5
// - Bouchon droit
version = 5;

arete = 19.096;
epaisseurParoi = 1.35;
r = 0.19; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 0.42;
bouchonOffset = 0.4;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r;

include <Octahedron_base.scad>;

// octahedron(arete);
// octa_creux();
// decoupe_bouchon();
corps_ouvert();
// bouchon();
// trou();
// support();

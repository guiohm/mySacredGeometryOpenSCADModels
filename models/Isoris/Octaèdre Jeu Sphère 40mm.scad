// Octaèdre Jeu sphère 40mm

// changelog
// v5
// - Bouchon droit
version = 5;

arete = 31.822;
epaisseurParoi = 1.5;
r = 0.19; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 0.42;
bouchonOffset = 0.6;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r/2;

include <Octahedron_base.scad>;

// octahedron(arete);
// octa_creux();
// decoupe_bouchon();
corps_ouvert();
// bouchon();
// trou();
// support();

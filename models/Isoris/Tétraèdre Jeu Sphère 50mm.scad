// Tetraèdre Jeu Sphère 50mm

// changelog
// v5
// - Bouchon droit
// - Plot fixation mortier
version = 5;

arete = 61.262;
epaisseurParoi = 1.5;
r = 0.29; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 1.6;
bouchonOffset = 0.2;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r/2;

include <Tetrahedron_base.scad>;

//tetrahedron(arete);
//tetra_creux();
//decoupe_bouchon();
// rotate_on_side()
// corps_ouvert();
bouchon();
//trou();

// Tetraèdre jeu sphère 33mm

// changelog
// v5
// - Bouchon droit
// - Plot fixation mortier
version = 5;

arete = 40.433;
epaisseurParoi = 1.4;
r = 0.19; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 1.4;
bouchonOffset = 0.1;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r/2;

include <Tetrahedron_base.scad>;

//tetrahedron(arete);
//tetra_creux();
//decoupe_bouchon();
// rotate_on_side() corps_ouvert();
bouchon();
//trou();

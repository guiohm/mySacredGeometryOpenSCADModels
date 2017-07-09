// Icosaèdre Jeu Sphère 33mm

version = 5;

// _arete = 0;
_circumradius = 17.353;

include <Icosaedre_base.scad>;

r = 0.19; // résolution d'impression sur l'axe Z
epaisseurParoi = 1.35 ;
bottom_hole = 0; // on || off
bottom_hole_diameter = 1.5;
side_hole = 0;
side_hole_diameter = 1.5;
//bouchonRadiusInscritOffset = 0.3;

// Distance entre la paroi extérieure et la découpe.
// Le minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 0.3;
bouchonOffset = 0.2;
// TODO: bouchonThickness is not the real one: 0.8 gives full thickness
bouchonThickness = .8*epaisseurParoi;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r/2;

//ico_creux();
//decoupe_bouchon();
// corps_ouvert();
bouchon();
//trou();
//support();

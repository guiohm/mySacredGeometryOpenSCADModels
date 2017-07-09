// Dodécaèdre Sphère 60mm

// Uncomment only one of the 3 next variables.
// The 2 other will be automagically computed.
// _arete = 10;
_diameter = 60;
// _hauteurExt = 22.2703;

include <Dodecaedre_base.scad>;

r = 0.29; // résolution d'impression sur l'axe Z
epaisseurParoi = 1.5; //1.19
bottom_hole = 0; // on || off
bottom_hole_diameter = 1.2;
bouchon_hole = 0; // on || off
side_hole = 0; // on || off
side_hole_diameter = 1;

// distance entre la paroi extérieure et la découpe
offset_decoupe_bouchon = 0.42;
bouchonOffset = 0.3;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r;

corps_ouvert();
// bouchon();

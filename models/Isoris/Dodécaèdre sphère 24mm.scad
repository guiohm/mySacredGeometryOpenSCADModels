// Uncomment only one of the 3 next variables.
// The 2 other will be automagically computed.
// _arete = 10;
_diameter = 24;
// _hauteurExt = 22.2703;

include <Dodecaedre_base.scad>;

r = 0.19; // résolution d'impression sur l'axe Z
epaisseurParoi = 1.35; //1.19
bottom_hole = 1; // on || off
bottom_hole_diameter = 1.2;
bouchon_hole = 0; // on || off
side_hole = 0; // on || off
side_hole_diameter = 1;

// distance entre la paroi extérieure et la découpe
offset_decoupe_bouchon = 0.42;
bouchonOffset = 0.4;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = 0;

corps_ouvert();
// bouchon();

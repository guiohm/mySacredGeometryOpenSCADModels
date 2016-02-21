
// Uncomment only one of the 3 next variables.
// The 2 other will be automagically computed.
// _arete = 10;
_diameter = 100;
// _hauteurExt = 22.2703;

include <Dodecaedre_base.scad>;

epaisseurParoi = 1.5;
diametreTrouBouchon = 1.6;
bouchonOffset = 0.3;
r = 0.19; // résolution d'impression sur l'axe Z

//dode_creux();
//decoupe_bouchon();
corps_ouvert();
//bouchon_avec_attache();
//bouchon();
//bouchon_trou();

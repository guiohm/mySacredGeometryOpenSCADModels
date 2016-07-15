include <Dodécaèdre Christique pendentif sphère 33mm.scad>;

//arete = 21.409;
diameter = 28;
creux = 1; // creux ou plein || 1 ou 0
paroi = 1;
bouchon = 1; // 1 ou 0
corps = 0; // 1 ou 0
rotate_body = 0;
bottom_hole = 1; // 1 ou 0
bottom_hole_diameter = 1.5;
bouchonOffset = 0.6;
r = 0.19; // résolution d'impression sur l'axe Z

// Controle rotation viewport quand animation en route
//$vpr = [70, 0, $t * 180];

/* Forme
Choix parmi:
- 0 => Etoilé
- 1 => Christique
- 2 => Christique_inversé
- 3 => Pentakis // (all points on sphere)
- 4 => Animate // voir plus bas pour plus d'infos
*/
forme_ID = 1;

/////////


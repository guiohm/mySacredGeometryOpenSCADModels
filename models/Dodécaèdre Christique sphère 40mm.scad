arete = 12;
creux = 1; // creux ou plein || 1 ou 0
paroi = 1.5;
echelleReductionAjustementBouchon = 0.965;
bouchon = 1; // 1 ou 0
corps = 0; // 1 ou 0

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

function dodeca_ext_radius(a) = 
    a/2*(sqrt(2));
    
function dodeca_sphere_inscrite_radius(a) = 
    a*sqrt(5/8+11/(8*sqrt(5)));
    
function dodeca_arete_from_sphere_inscrite(radius) = 
    radius/sqrt(5/8+11/(8*sqrt(5)));    

spike = [
    2.3417, // Etoilé, scale 1 is arete = 1.236 mm, diametre = 6.24 mm, arete pyramide = 2 mm
    0.8944, // Christique, scale 1 is arete = 1.236 mm, diametre = 4.05 mm
    -0.8944, // Christique inversé
    0.4279 // Pentakis
];

if (forme_ID == 4) {
    Animate();
} else {  
    if (creux == 0) {
        small_stellated_dodecahedron(spike[forme_ID], small_stellated_dodecahedron);
    } else {
        if (corps == 1) {
            corps_ouvert();
        }
        if (bouchon == 1) {
            bouchon();
        }
    }
}


//		poly_creux();
//		decoupe_bouchon();

module corps_ouvert() {
    rotate([180, 0, 0])
	difference() {
		poly_creux();
		decoupe_bouchon();
	}
}

module poly_creux() {
    areteInt = dodeca_arete_from_sphere_inscrite(dodeca_sphere_inscrite_radius(arete)-paroi);
                         
    echo("arete int: ", areteInt);
    
    difference() {
        small_stellated_dodecahedron(spike[forme_ID], arete);
        small_stellated_dodecahedron(spike[forme_ID], areteInt);
    }
}

module decoupe_bouchon(scale=1) {
    distance = dodeca_sphere_inscrite_radius(arete);
	rotate([0,0,36]) translate([0,0, distance])
		cylinder(99, r=arete*0.853, $fn=5, center=false);
	rotate([0,0,36]) translate([0,0, distance-paroi])
		cylinder(paroi, r=(arete-paroi)*0.85*scale, $fn=5, center=false);
}

module supplement_feuillure_bouchon() {
    distance = dodeca_sphere_inscrite_radius(arete);
    rotate([0,0,36]) translate([0,0, distance-paroi-1])
    difference() {   
		cylinder(paroi+1, r=(arete-paroi)*0.85, $fn=5, center=false);
		cylinder(paroi+1, r=(arete-2*paroi)*0.85, $fn=5, center=false);
    }
}

module bouchon() {
//	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.995])
	difference () {
        intersection() {
            union() {
                poly_creux();
                supplement_feuillure_bouchon();
            }
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
	}
}

// }}

/*
animates the single parameter of the
module small_stellated_dodecahedron

1/ choose animate in the view menu
2/ sets fps to an appropiate number for
your machine - 20 is good
3/ set steps to a number that keeps the
change from happening too slowly or
too fast - 200 is good
*/
module Animate() {
    small_stellated_dodecahedron(-3.4317*abs(2*$t-1)+2.4317);
}

// Étoilé
// scale 1 is arete = 1.236 mm, diametre = 6.24 mm, arete pyramide = 2 mm
module Etoile(a) {
    small_stellated_dodecahedron(2.3417, a);
}

// Christique
// scale 1 is arete = 1.236 mm, diametre = 4.05 mm
module Christique(a) {
    small_stellated_dodecahedron(0.8944, a);
}

// Christique inversé
module Christique_inv(a) {
    small_stellated_dodecahedron(-0.8944, a);
}

// Pentakis (all points on sphere)
module Pentakis(a) {
    small_stellated_dodecahedron(0.4279, a);
}

module small_stellated_dodecahedron(scale, ar)
{
a=scale*0.61803;
b=scale*0.38197;
    
length = ar ? ar : arete;
echo("length:", length);
// scale(1) => arete 1.236 mm
scale(length/1.236)

// Posé sur 3 pointes
//rotate([20.91, 0, 0])

// Posé sur 1 pointe
rotate([0, 31.72, 0])

/*
constructed from 12 pentagonal pyramids placed
on the faces of a dodecahedron.
first 20 points are the vertices of a dodecahedron
next 12 points are the vertices of the centers
of the faces of the dodecahedron

if scale = 0 a dodecahedron is created

if scale is positive the centers of the
faces are moved out fron the center of the
dodecahedron

if scale is negative the centers of the
faces are moved in towards the center of the
dodecahedron

the apex angles of the triangles that make up
the faces of the stellated dodecahedron
are 36 degrees - the scale factor that
makes a small stellated dodecahedron
is approximately 2.3417
length of side of pentagonal pyramid for
small stellated dodecahedron = 2

the apex angles of the triangles that make up
the faces of a pentakis dodecahedron ( one of
the Catalan solids) are about 68.619 degrees
the scale factor to make one is ca 0.4279

if len = length of the sides of the
pentagonal pyramid then approximately

scale = + or - sqrt((len*len/0.52786) - 2.09443)

lengths of the sides of the base are sqrt(5)-1
or 1.23607 to make equilateral triangles scale
factor is 0.8944

distance from centers of faces to origin ca 1.37638
distance from dodecahedral points to origin sqrt(3)




pcm

*/

polyhedron
       (points = [
                 [   1.00000,   1.00000,   1.00000],
                 [   1.00000,   1.00000,  -1.00000],
                 [   1.00000,  -1.00000,   1.00000],
                 [   1.00000,  -1.00000,  -1.00000],
                 [  -1.00000,   1.00000,   1.00000],
                 [  -1.00000,   1.00000,  -1.00000],
                 [  -1.00000,  -1.00000,   1.00000],
                 [  -1.00000,  -1.00000,  -1.00000],
                 [   0.00000,   0.61803,   1.61803],
                 [   0.00000,   0.61803,  -1.61803],
                 [   0.00000,  -0.61803,   1.61803],
                 [   0.00000,  -0.61803,  -1.61803],
                 [   0.61803,   1.61803,   0.00000],
                 [   0.61803,  -1.61803,   0.00000],
                 [  -0.61803,   1.61803,   0.00000],
                 [  -0.61803,  -1.61803,   0.00000],
                 [   1.61803,   0.00000,   0.61803],
                 [   1.61803,   0.00000,  -0.61803],
                 [  -1.61803,   0.00000,   0.61803],
                 [  -1.61803,   0.00000,  -0.61803],
                 [   1.17082+a,   0.72361+b,   0.00000],
                 [   0.72361+b,   0.00000,   1.17082+a],
                 [   0.00000,   1.17082+a,   0.72361+b],
                 [   0.00000,   1.17082+a,  -0.72361-b],
                 [   0.72361+b,   0.00000,  -1.17082-a],
                 [   1.17082+a,  -0.72361-b,   0.00000],
                 [   0.00000,  -1.17082-a,   0.72361+b],
                 [   0.00000,  -1.17082-a,  -0.72361-b],
                 [  -0.72361-b,   0.00000,   1.17082+a],
                 [  -1.17082-a,   0.72361+b,   0.00000],
                 [  -0.72361-b,   0.00000,  -1.17082-a],
                 [  -1.17082-a,  -0.72361-b,   0.00000],
                   ],

           faces = [

                [0,20,16],[16,20,17],[17,20,1],
                [1,20,12],[12,20,0],
                [0,21,8],[8,21,10],[10,21,2],
                [2,21,16],[16,21,0],
                 [0,22,12],[12,22,14],[14,22,4],
                [4,22,8],[8,22,0],
                [1,23,9],[9,23,5],[5,23,14],
                [14,23,12],[12,23,1],
                [1,24,17],[17,24,3],[3,24,11],
                [11,24,9],[9,24,1],
                [16,25,2],[17,25,16],[3,25,17],
                 [13,25,3],[2,25,13],
                 [2,26,10],[10,26,6],[6,26,15],
                 [15,26,13],[13,26,2],
                 [3,27,13],[13,27,15],[15,27,7],
                 [7,27,11],[11,27,3],
                [4,28,18],[18,28,6],[6,28,10],
                 [10,28,8],[8,28,4],
                 [4,29,14],[14,29,5],[5,29,19],
                 [19,29,18],[18,29,4],
                  [5,30,9],[9,30,11],[11,30,7],
                 [7,30,19],[19,30,5],
                 [6,31,18],[18,31,19],[19,31,7],
                 [7,31,15],[15,31,6],

                 ]
      );
}

arete = 10;
creux = 1; // creux ou plein || 1 ou 0
paroi = 1.5;
echelleReductionAjustementBouchon = 0.985;
bouchon = 0; // 1 ou 0
corps = 1; // 1 ou 0

/* Forme
Choix parmi:
- 0 => Animate // voir plus bas pour plus d'infos
- 1 => Augmenté
- 2 => Phi
- 3 => Pi
- 4 => 40 faces, rhombique ?
- 5 => Tous les sommets sur une spère ?
- 6 => étoilé
- 7 => tous les sommets sur un dodécaèdre
- 8 => Ico
- 9 =>
*/
forme_ID = 1;

/////////
Cphi = (1+sqrt(5))/2;
Cpi = 3.14159;

function dodeca_ext_radius(a) =
    a/2*(sqrt(2));

function dodeca_sphere_inscrite_radius(a) =
    a*sqrt(5/8+11/(8*sqrt(5)));

function dodeca_arete_from_cercle_inscrite(radius) =
    radius/sqrt(5/8+11/(8*sqrt(5)));

areteInt = dodeca_arete_from_cercle_inscrite(dodeca_sphere_inscrite_radius(arete)-paroi);

echo("areteInt:", areteInt);

spike = [
    1.048, // Augmenté (tétraèdres sur chaque face)
    Cphi,
    Cpi,
    1.9,
    sqrt(Cpi),
    0.72,
    1.38,
    2.18
];

if (forme_ID == 0) {
    Animate();
} else {
    if (creux == 0) {
        icosaedre_augmented(arete, spike[forme_ID-1]);
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
	difference() {
		poly_creux();
//		decoupe_bouchon();
	}
}

module poly_creux() {
    difference() {
        icosaedre_augmented(arete, spike[forme_ID-1]);
//        icosaedre_augmented(areteInt, spike[forme_ID]);
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
    icosaedre_augmented(1, 3*abs(2*$t-1)+1);
}

// Étoilé
// scale 1 is arete = 1.236 mm, diametre = 6.24 mm, arete pyramide = 2 mm
module Etoile(a) {
    icosaedre_augmented(a, 2.3417);
}

// Christique
// scale 1 is arete = 1.236 mm, diametre = 4.05 mm
module Christique(a) {
    icosaedre_augmented(a, 0.8944);
}

// Christique inversé
module Christique_inv(a) {
    icosaedre_augmented(a, -0.8944);
}

// Pentakis (all points on sphere)
module Pentakis(a) {
    icosaedre_augmented(a, 0.4279);
}

module icosaedre_augmented(arete=1, amount)
{
    //rad = Cphi;
    rad = 20;
//    s = rad/Cphi;
    s = rad/amount;
//    s = rad/Cpi/3; // inverted
    echo("drawing with arete=", arete);
    // scale(1) => arete 1.236 mm


	// Convert spherical to cartesian
	function sph_to_cart(c, rad) = [
		rad*sin(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))*cos(atan2(c[1],c[0])),
		rad*sin(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))*sin(atan2(c[1],c[0])),
		rad*cos(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))
		];


	//================================================
	//	Icosahedron
	//================================================
	//
	// (0, +-1, +-Cphi)
	// (+-Cphi, 0, +-1)
	// (+-1, +-Cphi, 0)

	function icosa_unit(rad) = [
		sph_to_cart([0, +1, +Cphi], rad),
		sph_to_cart([0, +1, -Cphi], rad),
		sph_to_cart([0, -1, -Cphi], rad),
		sph_to_cart([0, -1, +Cphi], rad),
		sph_to_cart([+Cphi, 0, +1], rad),
		sph_to_cart([+Cphi, 0, -1], rad),
		sph_to_cart([-Cphi, 0, -1], rad),
		sph_to_cart([-Cphi, 0, +1], rad),
		sph_to_cart([+1, +Cphi, 0], rad),
		sph_to_cart([+1, -Cphi, 0], rad),
		sph_to_cart([-1, -Cphi, 0], rad),
		sph_to_cart([-1, +Cphi, 0], rad),
        [  1.00000*s,  1.00000*s,  1.00000*s],
        [  1.00000*s,  1.00000*s, -1.00000*s],
        [  1.00000*s, -1.00000*s,  1.00000*s],
        [  1.00000*s, -1.00000*s, -1.00000*s],
        [ -1.00000*s,  1.00000*s,  1.00000*s],
        [ -1.00000*s,  1.00000*s, -1.00000*s],
        [ -1.00000*s, -1.00000*s,  1.00000*s],
        [ -1.00000*s, -1.00000*s, -1.00000*s],
        [  0.61803*s,  0.00000*s,  1.61803*s],
        [  0.61803*s,  0.00000*s, -1.61803*s],
        [ -0.61803*s,  0.00000*s,  1.61803*s],
        [ -0.61803*s,  0.00000*s, -1.61803*s],
        [  1.61803*s,  0.61803*s,  0.00000*s],
        [ -1.61803*s,  0.61803*s,  0.00000*s],
        [  1.61803*s, -0.61803*s,  0.00000*s],
        [ -1.61803*s, -0.61803*s,  0.00000*s],
        [  0.00000*s,  1.61803*s,  0.61803*s],
        [  0.00000*s,  1.61803*s, -0.61803*s],
        [  0.00000*s, -1.61803*s,  0.61803*s],
        [  0.00000*s, -1.61803*s, -0.61803*s],
		];

	icosa_faces = [
		[3,0,20],[3,4,20],[4,0,20],
		[3,4,14],[3,9,14],[9,4,14],
		[3,9,30],[3,10,30],[10,9,30],
		[3,10,18],[3,7,18],[7,10,18],
		[3,7,22],[3,0,22],[0,7,22],
		[0,8,12],[0,4,12],[4,8,12],
		[0,7,16],[0,11,16],[11,7,16],
		[0,11,28],[0,8,28],[8,11,28],
		[4,8,24],[4,5,24],[5,8,24],
		[4,5,26],[4,9,26],[9,5,26],
		[7,10,27],[7,6,27],[6,10,27],
		[7,6,25],[7,11,25],[11,6,25],
		[9,5,15],[9,2,15],[2,5,15],
		[9,2,31],[9,10,31],[10,2,31],
		[2,6,19],[2,10,19],[10,6,19],
		[1,5,13],[1,8,13],[8,5,13],
		[1,8,29],[1,11,29],[11,8,29],
		[1,11,17],[6,11,17],[1,6,17],
		[5,1,21],[5,2,21],[2,1,21],
		[2,1,23],[2,6,23],[6,1,23],
		];

    scale(arete/1.236)
	polyhedron(icosa_unit(rad), faces = icosa_faces);

//a=scale*0.61803;
//b=scale*0.38197;

// Posé sur 3 pointes
//rotate([20.91, 0, 0])

// Posé sur 1 pointe
//rotate([0, 31.72, 0])

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

//polyhedron
//       (points = [
//                 [   1.00000,   1.00000,   1.00000],
//                 [   1.00000,   1.00000,  -1.00000],
//                 [   1.00000,  -1.00000,   1.00000],
//                 [   1.00000,  -1.00000,  -1.00000],
//                 [  -1.00000,   1.00000,   1.00000],
//                 [  -1.00000,   1.00000,  -1.00000],
//                 [  -1.00000,  -1.00000,   1.00000],
//                 [  -1.00000,  -1.00000,  -1.00000],
//                 [   0.00000,   0.61803,   1.61803],
//                 [   0.00000,   0.61803,  -1.61803],
//                 [   0.00000,  -0.61803,   1.61803],
//                 [   0.00000,  -0.61803,  -1.61803],
//                 [   0.61803,   1.61803,   0.00000],
//                 [   0.61803,  -1.61803,   0.00000],
//                 [  -0.61803,   1.61803,   0.00000],
//                 [  -0.61803,  -1.61803,   0.00000],
//                 [   1.61803,   0.00000,   0.61803],
//                 [   1.61803,   0.00000,  -0.61803],
//                 [  -1.61803,   0.00000,   0.61803],
//                 [  -1.61803,   0.00000,  -0.61803],
//                 [   1.17082+a,   0.72361+b,   0.00000],
//                 [   0.72361+b,   0.00000,   1.17082+a],
//                 [   0.00000,   1.17082+a,   0.72361+b],
//                 [   0.00000,   1.17082+a,  -0.72361-b],
//                 [   0.72361+b,   0.00000,  -1.17082-a],
//                 [   1.17082+a,  -0.72361-b,   0.00000],
//                 [   0.00000,  -1.17082-a,   0.72361+b],
//                 [   0.00000,  -1.17082-a,  -0.72361-b],
//                 [  -0.72361-b,   0.00000,   1.17082+a],
//                 [  -1.17082-a,   0.72361+b,   0.00000],
//                 [  -0.72361-b,   0.00000,  -1.17082-a],
//                 [  -1.17082-a,  -0.72361-b,   0.00000],
//                   ],
//
//           faces = [
//
//                [0,20,16],[16,20,17],[17,20,1],
//                [1,20,12],[12,20,0],
//                [0,21,8],[8,21,10],[10,21,2],
//                [2,21,16],[16,21,0],
//                 [0,22,12],[12,22,14],[14,22,4],
//                [4,22,8],[8,22,0],
//                [1,23,9],[9,23,5],[5,23,14],
//                [14,23,12],[12,23,1],
//                [1,24,17],[17,24,3],[3,24,11],
//                [11,24,9],[9,24,1],
//                [16,25,2],[17,25,16],[3,25,17],
//                 [13,25,3],[2,25,13],
//                 [2,26,10],[10,26,6],[6,26,15],
//                 [15,26,13],[13,26,2],
//                 [3,27,13],[13,27,15],[15,27,7],
//                 [7,27,11],[11,27,3],
//                [4,28,18],[18,28,6],[6,28,10],
//                 [10,28,8],[8,28,4],
//                 [4,29,14],[14,29,5],[5,29,19],
//                 [19,29,18],[18,29,4],
//                  [5,30,9],[9,30,11],[11,30,7],
//                 [7,30,19],[19,30,5],
//                 [6,31,18],[18,31,19],[19,31,7],
//                 [7,31,15],[15,31,6],
//
//                 ]
//      );
}

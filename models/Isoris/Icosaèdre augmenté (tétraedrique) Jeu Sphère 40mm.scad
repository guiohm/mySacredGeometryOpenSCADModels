arete = 14.274;
creux = 1; // creux ou plein || 1 ou 0
paroi = 1.5;
echelleReductionAjustementBouchon = 0.97;
bouchon = 0; // 1 ou 0
corps = 1; // 1 ou 0
support = 0;

r = 0.19; // résolution d'impression sur l'axe Z
ico_sch = [3,5];

use <../lib/maths.scad>;

function ico_ext_radius(a) =
    a*1/4*(sqrt(10+2*sqrt(5)));

function ico_int_radius(a) =
    a/12*(3*sqrt(3)+sqrt(15));

function ico_arete_from(int_radius) =
    int_radius*12/(3*sqrt(3)+sqrt(15));

externalRadius = ico_ext_radius(arete);
internalRadius = ico_ext_radius(
                    ico_arete_from(
                        ico_int_radius(arete)-paroi));

echo(externalRadius=externalRadius);
echo(internalRadius=internalRadius);

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
        if (corps) {
            corps_ouvert();
            support_base();
        }
        if (bouchon) {
            bouchon();
        }
        if (support) {
            bague_support();
        }
    }
}


//		poly_creux();
//		decoupe_bouchon();

module bague_support() {
    // render()
    difference() {
        // translate([0,0,-1.4*externalRadius])
        //     cylinder(r=8, h=8, center=true);
        rotate([180]) translate([0, 0, 0.77*externalRadius])
        parabolic_shell2(11, 0.13, 24, 3, flat_border=true);

        rotate_pointe()
            #icosaedre_augmented(externalRadius, spike[forme_ID-1]);

        // holes
        for (i=[1:3]) {
            // rotate([0, 270, i*360/3+60]) translate([-externalRadius*1.4,0,-10])
            // cylinder(h=20, r=6, center=true, $fn=3);

            rotate([-90, 0, i*360/3+30]) translate([0,externalRadius*1+7.3,-6])
            linear_extrude(height=10, center=true, convexity=10, twist=0, scale = 0.4) {
                translate([0,-10,0])
                inner_parabola(9.5, 0.11, 18);
            }
        }
    }
}

module corps_ouvert() {
    rotate([0,180,0])
	render(convexity = 2) difference() {
		poly_creux();
		decoupe_bouchon();
	}
}

module poly_creux() {
    rotate_sur_5_pointes()
    difference() {
        icosaedre_augmented(externalRadius, spike[forme_ID-1]);
        icosaedre_augmented(internalRadius, spike[forme_ID-1]);
    }
}

module decoupe_bouchon(scale=1) {
    distance = ico_int_radius(arete)*0.5625;
	rotate([0,0,54]) translate([0,0, distance])
		cylinder(99, r=arete*2, $fn=5, center=false);
    scale2 = pow(scale,4);
	rotate([0,0,54]) translate([0,0, distance-paroi+0.5+((paroi-0.5)-(paroi-0.5)*scale2)])
		cylinder((paroi-0.5)*scale2, r=(arete-paroi)*0.9*scale, $fn=5, center=false);
}

module supplement_feuillure_bouchon(scale=1) {
    distance = ico_int_radius(arete)*0.5625;
    rotate([0,0,54]) translate([0,0, distance-paroi-1])
    difference() {
		cylinder(paroi+1, r=(arete-paroi)*0.9*scale, $fn=5, center=false);
		cylinder(paroi+1, r=(arete-2*paroi)*0.9*scale, $fn=5, center=false);
    }
}

module bouchon() {
    rotate([0,180,0])
	render(convexity = 2) difference () {
        intersection() {
            union() {
                poly_creux();
                supplement_feuillure_bouchon(echelleReductionAjustementBouchon);
            }
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
	}
}

module support_base() {
    difference() {
        for (i = [1:5]) {
            rotate([0,0,360/5*i])
            translate([0,arete*1.08, -internalRadius*0.9]) rotate([0,-8.8,90])
            cylinder(5, r=arete*0.6, $fn=3, center=false);
        }
        translate([0,0,-internalRadius*1.51])
            cylinder(internalRadius, r=999, $fn=6, center=false);
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

module rotate_sur_5_pointes() {
    rotate([31.72, 0, 0]) children();
}

module rotate_pointe() {
    rotate([0, 20.905, 0]) children();
}


module icosaedre_augmented(rad=20, amount)
{
    //rad = Cphi;
//    s = rad/Cphi;
    s = rad/amount;
//    s = rad/Cpi/3; // inverted
    echo("drawing with arete=", arete);


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
		[3,0,20],[3,20,4],[4,20,0],
		[3,4,14],[3,14,9],[9,14,4],
		[3,9,30],[3,30,10],[10,30,9],
		[3,10,18],[3,18,7],[7,18,10],
		[3,7,22],[3,22,0],[0,22,7],
		[0,8,12],[0,12,4],[4,12,8],
		[0,7,16],[0,16,11],[11,16,7],
		[0,11,28],[0,28,8],[8,28,11],
		[4,8,24],[4,24,5],[5,24,8],
		[4,5,26],[4,26,9],[9,26,5],
		[7,10,27],[7,27,6],[6,27,10],
		[7,6,25],[7,25,11],[11,25,6],
		[9,5,15],[9,15,2],[2,15,5],
		[9,2,31],[9,31,10],[10,31,2],
		[2,6,19],[2,19,10],[10,19,6],
		[1,5,13],[1,13,8],[8,13,5],
		[1,8,29],[1,29,11],[11,29,8],
		[1,11,17],[6,17,11],[1,17,6],
		[5,1,21],[5,21,2],[2,21,1],
		[2,1,23],[2,23,6],[6,23,1],
		];


    //a=scale*0.61803;
    //b=scale*0.38197;

	polyhedron(icosa_unit(rad), faces = icosa_faces);

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

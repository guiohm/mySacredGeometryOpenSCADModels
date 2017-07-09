// Dodécaèdre / Ico Augmenté Sphère 84mm

version = 2;

color("green"){
// dode_bottom();
rotate([180,0])
dode_top();
}

arete = 21.27;
creux = 1; // creux ou plein || 1 ou 0
paroi = 1.5;
echelleReductionAjustementBouchon = 0.97;
bouchon = 0; // 1 ou 0
corps = 0; // 1 ou 0
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
      rotate([0,0,180])
      rotate_pointe()
      icosaedre_augmented(externalRadius, spike[forme_ID-1]);
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


//    poly_creux();
//    decoupe_bouchon();

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
    // rotate([0,180,0])
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
            translate([0,arete*1.08, -internalRadius*0.715]) rotate([0,-8.8,90])
            cylinder(5, r=arete*0.6, $fn=3, center=false);
        }
        translate([0,0,-internalRadius*1.49])
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
  //  Icosahedron
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





////////////////////////////
////////////////////////////

// Dodecahedron

// base coordinates
// source:  http://dmccooey.com/polyhedra/Dodecahedron.txt
// generated by  http://kitwallace.co.uk/3d/solid-to-scad.xq
Name = "Dodecahedron";
// 5 sided faces = 12
C0 = 0.809016994374947424102293417183;
C1 = 1.30901699437494742410229341718;
points = [
[ 0.0,  0.5,   C1],
[ 0.0,  0.5,  -C1],
[ 0.0, -0.5,   C1],
[ 0.0, -0.5,  -C1],
[  C1,  0.0,  0.5],
[  C1,  0.0, -0.5],
[ -C1,  0.0,  0.5],
[ -C1,  0.0, -0.5],
[ 0.5,   C1,  0.0],
[ 0.5,  -C1,  0.0],
[-0.5,   C1,  0.0],
[-0.5,  -C1,  0.0],
[  C0,   C0,   C0],
[  C0,   C0,  -C0],
[  C0,  -C0,   C0],
[  C0,  -C0,  -C0],
[ -C0,   C0,   C0],
[ -C0,   C0,  -C0],
[ -C0,  -C0,   C0],
[ -C0,  -C0,  -C0]];
faces = [
[ 12 ,  4, 14,  2,  0],
[ 16 , 10,  8, 12,  0],
[  2 , 18,  6, 16,  0],
[ 17 , 10, 16,  6,  7],
[ 19 ,  3,  1, 17,  7],
[  6 , 18, 11, 19,  7],
[ 15 ,  3, 19, 11,  9],
[ 14 ,  4,  5, 15,  9],
[ 11 , 18,  2, 14,  9],
[  8 , 10, 17,  1, 13],
[  5 ,  4, 12,  8, 13],
[  1 ,  3, 15,  5, 13]];
edges = [
[4,12],
[4,14],
[2,14],
[0,2],
[0,12],
[10,16],
[8,10],
[8,12],
[0,16],
[2,18],
[6,18],
[6,16],
[10,17],
[6,7],
[7,17],
[3,19],
[1,3],
[1,17],
[7,19],
[11,18],
[11,19],
[3,15],
[9,11],
[9,15],
[4,5],
[5,15],
[9,14],
[1,13],
[8,13],
[5,13]];
// ---------------------------------


// cut holes out of shell
eps=0.02;
radius=42;
shell_ratio=0.1;
prism_base_ratio=0.8;
prism_height_ratio=0.12;
prism_scale=1.15;
nfaces = [];
scale=1;

//insert

spoints = normalize(centre_points(points),radius);
sfaces = lhs_faces(faces,spoints);
cfaces =  select_nsided_faces(sfaces,nfaces);

hauteur = radius_sphere_inscrite(arete_from_sphere_circonscrite(radius))*2;

module base() {
    rotate([0,0,0])
        translate([0,0,-hauteur/2])
    difference() {
        cylinder(r=hauteur*0.37, h=2.01, $fn=5, center=false);
        rotate([0,0,180])
        cylinder(r1=0, r2=1, h=2.01, $fn=20, center=false);
    }
}

module plafond() {
    rotate([0,180,0]) base();
}

module dode_construct() {
    difference() {
        polyhedron(spoints,sfaces);
        scale(1-shell_ratio) polyhedron(spoints,sfaces);
        face_prisms_in(cfaces,spoints,prism_base_ratio,prism_scale,prism_height_ratio);
    }
}

module dodecahedron() {
scale(scale)
translate([0, 0, -hauteur/2])
 place_on_largest_face(sfaces,spoints)
   dode_construct();
}

module assemblage_dode() {
    union() {
        dodecahedron();
        base();
        plafond();
    }
}

module dode_bottom() {
    difference() {
        assemblage_dode();
        decoupe();
        plots(7.5, 1, 7);
    }
}

module dode_top() {
//    rotate([180,0,0])
    difference() {
        intersection() {
            assemblage_dode();
            union() {
                decoupe();
                plots(7.3, 1, 6.9);
            }
        }
        // for (i = [1:5]) {
        //   rotate([0, 0, 360/5*i])
        //     translate([24.3, 0, (-hauteur/2)+5-2.6]) rotate([0,0,0])
        //         #cylinder(d1=5, d2=5, h=5, $fn=5, center=true);
        // }
    }
}

module decoupe() {
    translate([0, 0, -hauteur/2+3.68])
        cylinder(h=666, d=666);
}

module plots(d, x, h) {
    for (i = [1:5]) {
      rotate([0, 0, 360/5*i])
        translate([25.5+x, 0, (-hauteur/2)+5.01]) rotate([0,0,72/2])
           cylinder(d1=d, d2=d, h=h, $fn=5, center=true);
            // linear_extrude(height = 20, scale = 1)
            //     square([longueur, largeur], center = true);
    }
}

//decoupe();
// #dode_top();
// dode_bottom();

function radius_sphere_inscrite(arete) =
    arete*sqrt(5/8+11/(8*sqrt(5)));

function arete_from_sphere_circonscrite(radius) =
    radius*4/(sqrt(3)+sqrt(15));

// ruler(10);

// functions for the construction of polyhedra
// chris wallace
// see http://kitwallace.tumblr.com/tagged/polyhedra for info


//  functions for creating the matrices for transforming a single point

function m_translate(v) = [ [1, 0, 0, 0],
                            [0, 1, 0, 0],
                            [0, 0, 1, 0],
                            [v.x, v.y, v.z, 1  ] ];

function m_rotate(v) =  [ [1,  0,         0,        0],
                          [0,  cos(v.x),  sin(v.x), 0],
                          [0, -sin(v.x),  cos(v.x), 0],
                          [0,  0,         0,        1] ]
                      * [ [ cos(v.y), 0,  -sin(v.y), 0],
                          [0,         1,  0,        0],
                          [ sin(v.y), 0,  cos(v.y), 0],
                          [0,         0,  0,        1] ]
                      * [ [ cos(v.z),  sin(v.z), 0, 0],
                          [-sin(v.z),  cos(v.z), 0, 0],
                          [ 0,         0,        1, 0],
                          [ 0,         0,        0, 1] ];

function vec3(v) = [v.x, v.y, v.z];
function transform(v, m)  = vec3([v.x, v.y, v.z, 1] * m);

function matrix_to(p0, p) =
                       m_rotate([0, atan2(sqrt(pow(p[0], 2) + pow(p[1], 2)), p[2]), 0])
                     * m_rotate([0, 0, atan2(p[1], p[0])])
                     * m_translate(p0);

function matrix_from(p0, p) =
                      m_translate(-p0)
                      * m_rotate([0, 0, -atan2(p[1], p[0])])
                      * m_rotate([0, -atan2(sqrt(pow(p[0], 2) + pow(p[1], 2)), p[2]), 0]);

function transform_points(list, matrix, i = 0) =
    i < len(list)
       ? concat([ transform(list[i], matrix) ], transform_points(list, matrix, i + 1))
       : [];


//  convert from point indexes to point coordinates

function as_points(indexes,points,i=0) =
     i < len(indexes)
        ?  concat([points[indexes[i]]], as_points(indexes,points,i+1))
        : [];

//  basic vector functions
function normal_r(face) =
     cross(face[1]-face[0],face[2]-face[0]);

function normal(face) =
     - normal_r(face) / norm(normal_r(face));

function centre(points) =
      vsum(points) / len(points);

// sum a list of vectors
function vsum(points,i=0) =
      i < len(points)
        ?  (points[i] + vsum(points,i+1))
        :  [0,0,0];

function ssum(list,i=0) =
      i < len(list)
        ?  (list[i] + ssum(list,i+1))
        :  0;


// add a vector to a list of vectors
function vadd(points,v,i=0) =
      i < len(points)
        ?  concat([points[i] + v], vadd(points,v,i+1))
        :  [];

function reverse_r(v,n) =
      n == 0
        ? [v[0]]
        : concat([v[n]],reverse_r(v,n-1));

function reverse(v) = reverse_r(v, len(v)-1);

function sum_norm(points,i=0) =
    i < len(points)
       ?  norm(points[i]) + sum_norm(points,i+1)
       : 0 ;

function average_radius(points) =
       sum_norm(points) / len(points);


// select one dimension of a list of vectors
function slice(v,k,i=0) =
   i <len(v)
      ?  concat([v[i][k]], slice(v,k,i+1))
      : [];

function max(v, max=-9999999999999999,i=0) =
     i < len(v)
        ?  v[i] > max
            ?  max(v, v[i], i+1 )
            :  max(v, max, i+1 )
        : max;

function min(v, min=9999999999999999,i=0) =
     i < len(v)
        ?  v[i] < min
            ?  min(v, v[i], i+1 )
            :  min(v, min, i+1 )
        : min;

function project(pts,i=0) =
     i < len(pts)
        ? concat([[pts[i][0],pts[i][1]]], project(pts,i+1))
        : [];

function contains(n, list, i=0) =
     i < len(list)
        ?  n == list[i]
           ?  true
           :  contains(n,list,i+1)
        : false;

// normalize the points to have origin at 0,0,0
function centre_points(points) =
     vadd(points, - centre(points));

//scale to average radius = radius
function normalize(points,radius) =
    points * radius /average_radius(points);

function select_nsided_faces(faces,nsides,i=0) =
  len(nsides) == 0
     ?  faces
     :  i < len(faces)
         ?  contains(len(faces[i]), nsides)
             ? concat([faces[i]],  select_nsided_faces(faces,nsides,i+1))
             : select_nsided_faces(faces,nsides,i+1)
         : [];

function longest_edge(face,max=-1,i=0) =
       i < len(face)
          ?  norm(face[i] - face[(i+1)% len(face)]) > max
             ?  longest_edge(face, norm(face[i] - face[(i+1)% len(face)]),i+1)
             :  longest_edge(face, max,i+1)
          : max ;

function point_edges(point,edges,i=0) =
    i < len(edges)
       ? point == edges[i][0] || point == edges[i][1]
         ? concat([edges[i]], point_edges(point,edges,i+1))
         : point_edges(point,edges,i+1)
       : [];

function select_nedged_points(points,edges,nedges,i=0) =
     i < len(points)
         ?  len(point_edges(i,edges)) == nedges
             ? concat([i],  select_nedged_points(points,edges,nedges,i+1))
             : select_nedged_points(points,edges,nedges,i+1)
         : [];

function triangle(a,b) = norm(cross(a,b))/2;

function face_area_centre(face,centre,i=0) =
    i < len(face)
       ?  triangle(
                face[i] - centre,
                face[(i+1) % len(face)] - centre)
          + face_area_centre(face,centre,i+1)
       : 0 ;

function face_area(face) = face_area_centre(face,centre(face));

function face_areas(faces,points,i=0) =
   i < len(faces)
      ? concat([[i,  face_area(as_points(faces[i],points))]] ,
               face_areas(faces,points,i+1))
      : [] ;

function max_area(areas, max=[-1,-1], i=0) =
   i <len(areas)
      ? areas[i][1] > max[1]
         ?  max_area(areas,areas[i],i+1)
         :  max_area(areas,max,i+1)
      : max;


function bbox(v) = [
   [min(slice(spoints,0)), max(slice(spoints,0))],
   [min(slice(spoints,1)), max(slice(spoints,1))],
   [min(slice(spoints,2)), max(slice(spoints,2))]
];

// check that all faces have a lhs orientation
function cosine_between(u, v) =(u * v) / (norm(u) * norm(v));

function lhs_faces(faces,points,i=0) =
     i < len(faces)
        ?  cosine_between(normal(as_points(faces[i],points)),
                         centre(as_points(faces[i],points))) < 0
            ?  concat([reverse(faces[i])],lhs_faces(faces,points,i+1))
            :  concat([faces[i]],lhs_faces(faces,points,i+1))
        : [] ;


function fs(p) = f(p[0],p[1],p[2]);

function modulate_point(p) =
    spherical_to_xyz(fs(xyz_to_spherical(p)));

function modulate_points(points,i=0) =
   i < len(points)
      ? concat([modulate_point(points[i])],modulate_points(points,i+1))
      : [];

function xyz_to_spherical(p) =
    [ norm(p), acos(p.z/ norm(p)), atan2(p.x,p.y)] ;

function spherical_to_xyz_full(r,theta,phi) =
    [ r * sin(theta) * cos(phi),
      r * sin(theta) * sin(phi),
      r * cos(theta)];

function spherical_to_xyz(s) =
     spherical_to_xyz_full(s[0],s[1],s[2]);

function select_large_faces(faces,points, min,i=0) =
  i < len(faces)
     ?  face_area(as_points(faces[i],points)) > min
       ? concat([faces[i]],  select_large_faces(faces,points,min,i+1))
       :select_large_faces(faces,points,min,i+1)
     : [];

function lower(char) =
    contains(char,"abcdefghijklmnopqrstuvwxyz") ;

function char_layer(char) =
    lower(char)
         ? str(char,"_")
         : char;

module write_char(font,char) {
    linear_extrude(height=1,convexity=10)
      import(file=str("write/",font,".dxf"),layer=char_layer(char));
};

module write_centred_char(font,char) {
    linear_extrude(height=1,convexity=10)
      translate([-2.5,-4,0])
          import(file=str("write/",font,".dxf"),layer=char_layer(char));
};
module engrave_face_word(faces,points,word,font,ratio,thickness) {
    for (i=[0:len(faces) - 1]) {
      if (i <len(word)) {
        f = as_points(faces[i],points);
        n = normal(f); c = centre(f);
        s = longest_edge(f) / 20* ratio;
           orient_to(c,n)
                translate([0,0,-thickness+eps])
                     scale([s,s,thickness])
                          write_centred_char(font,word[i]);
      }
  }
}

module orient_to(centre, normal) {
      translate(centre)
      rotate([0, 0, atan2(normal[1], normal[0])]) //rotation
      rotate([0, atan2(sqrt(pow(normal[0], 2)+pow(normal[1], 2)),normal[2]), 0])
      children();
}

module orient_from(centre, normal) {
      rotate([0, -atan2(sqrt(pow(normal[0], 2)+pow(normal[1], 2)),normal[2]), 0])
      rotate([0, 0, -atan2(normal[1], normal[0])]) //rotation
      translate(-centre)
      children();
}

module place_on_largest_face(faces,points) {
  largest = max_area(face_areas(faces,points));
  lpoints = as_points(faces[largest[0]],points);
  n = normal(lpoints); c = centre(lpoints);
  orient_from(c,-n)
  children();
}

module make_edge(edge, points, r) {
    p0 = points[edge[0]]; p1 = points[edge[1]];
    v = p1 -p0;
     orient_to(p0,v)
       cylinder(r=r, h=norm(v));
}

module make_edges(points, edges, r) {
   for (i =[0:len(edges)-1])
      make_edge(edges[i],points, r);
}

module make_vertices(points,r) {
   for (i = [0:len(points)-1])
      translate(points[i]) sphere(r);
}

module face_prism (face,prism_base_ratio,prism_scale,prism_height_ratio) {
    n = normal(face); c= centre(face);
    m = matrix_from(c,n);
    tpts =  prism_base_ratio * transform_points(face,m);
    max_length = longest_edge(face);
    xy = project(tpts);
      linear_extrude(height=prism_height_ratio * max_length, scale=prism_scale)
          polygon(points=xy);
}

module face_prisms_in(faces,points,prism_base_ratio,prism_scale,prism_height_ratio) {
    for (i=[0:len(faces) - 1]) {
       f = as_points(faces[i],points);
       n = normal(f); c = centre(f);
       orient_to(c,n)
          translate([0,0,eps])
               mirror() rotate([0,180,0])
                   face_prism(f,prism_base_ratio,prism_scale,prism_height_ratio);
    }
}

module face_prisms_out(faces,points,prism_base_ratio,prism_scale,prism_height_ratio) {
    for (i=[0:len(faces) - 1])  {
       f = as_points(faces[i],points);
       n = normal(f); c = centre(f);
       orient_to(c,n)
          translate([0,0,-eps])
               face_prism(f,prism_base_ratio,prism_scale,prism_height_ratio);
    }
}

module face_prisms_through(faces,points,prism_base_ratio,prism_scale,prism_height_ratio) {
    for (i=[0:len(faces) - 1]) {
       f = as_points(faces[i],points);
       n = normal(f); c = centre(f);
       orient_to(c,n)
          translate([0,0,prism_height_ratio*longest_edge(f)/2])
               mirror() rotate([0,180,0])
                   face_prism(f,prism_base_ratio,prism_scale,prism_height_ratio);
    }
}
module ruler(n) {
   for (i=[0:n-1])
       translate([(i-n/2 +0.5)* 10,0,0]) cube([9.8,5,2], center=true);
}

module ground(size=50) {
   translate([0,0,-size]) cube(2*size,center=true);
}

module cross_section(size=50) {
   translate([0,0,-size]) cube(2*size);
}

module ring(radius,thickness,height) {
   difference() {
      cylinder(h=height,r=radius);
      translate([0,0,-eps]) cylinder(h=height+2*eps,r=radius - thickness);
   }
}

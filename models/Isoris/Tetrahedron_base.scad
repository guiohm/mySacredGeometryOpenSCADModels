// Tetraèdre Jeu Sphère 50mm

// To use this file, copy && modify the header section
// then uncomment the needed parts.

////////////////////
//  HEADER START  //
////////////////////

// changelog
// v5
// - Nouvelle feuillure bouchon droit
// - plot blocage mortier
_version = 5;

// arete = 39.783;
// epaisseurParoi = 1.5;
// r = 0.19; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
// offset_decoupe_bouchon = 1.6;
// bouchonOffset = 0.3;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
// decoupeZOffset = -r;

// You want to uncomment this...
// include <Tetrahedron_base.scad>;

// tetrahebouchon();
// rotate_on_side()
// corps_ouvert();
// bouchon();
// trou();

////////////////////
//   HEADER END   //
////////////////////

tetra_sch = [3,3];
// dihedral_angle = acos(1/3);
dihedral_angle = plat_dihedral(tetra_sch);
Cpi = 3.14159;
Cphi = (1+sqrt(5))/2;
Cepsilon = 0.00000001;

include <../../lib/maths.scad>;

function tetra_ext_radius(a) =
    a/4*sqrt(6);

function tetra_int_radius(a) =
    a/12*sqrt(6);

function tetra_arete_from(radius) =
    radius*12/sqrt(6);

externalRadius = tetra_ext_radius(arete);
internalRadius = tetra_ext_radius(
                    tetra_arete_from(
                        tetra_int_radius(arete)-epaisseurParoi));
decoupe_bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 3) - offset_decoupe_bouchon,
              3);
bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 3) - offset_decoupe_bouchon - bouchonOffset,
              3);

echo(externalRadius);
echo(internalRadius);

module rotate_on_side() {
    rotate([-(180-dihedral_angle), 0])
        children();
}

module corps_ouvert() {
    difference() {
        union() {
            tetra_creux();
            // #feuillure(decoupe_bouchon_radius);
            plot();
        }
        #decoupe_bouchon(decoupe_bouchon_radius, decoupeZOffset);
    }
}

module plot() {
    height = 0.14*arete;
    radius = 0.05*arete;
    rotate([180-dihedral_angle, 0])
    translate([0,0,-tetra_int_radius(arete)]) {
        cylinder(h=height, r1=radius, r2=0.1, center=false, $fn=3);
        rotate([0,0,60])
        cylinder(h=height, r1=radius, r2=0.1, center=false, $fn=3);
    }
}

module bouchon() {
    // rotate([180, 0, 0])
    difference () {
        intersection() {
            tetra_creux();
            decoupe_bouchon(bouchon_radius);
        }
    }
}

module tetra_creux() {
    difference() {
        tetrahedron(externalRadius);
        tetrahedron(internalRadius);
    }
}

module decoupe_bouchon(radius, zOffset = 0) {
  distance = tetra_int_radius(arete)+zOffset;
  rotate([0,0,30]) translate([0,0,-distance-1])
    cylinder(epaisseurParoi+1, r=radius, $fn=3);
}

module feuillure(radius) {
  distance = tetra_int_radius(arete)+epaisseurParoi+.8*epaisseurParoi;
  difference() {
    rotate([0,0,30]) translate([0,0,-distance])
      cylinder(.8*epaisseurParoi, r=radius+.5*epaisseurParoi, $fn=3);
    rotate([0,0,30]) translate([0,0,-distance])
      cylinder(.8*epaisseurParoi, r1=radius+.5*epaisseurParoi, r2=radius-1.2*epaisseurParoi, $fn=3);
  }
}


module tetrahedron(rad) {
    // create an instance of a spherical coordinate
    // long - rotation around z -axis
    // lat - latitude, starting at 0 == 'north pole'
    // rad - distance from center
    function sph(long, lat, rad=1) = [long, lat, rad];

    // Convert spherical to cartesian
    function sph_to_cart(s) = [
    clean(s[2]*sin(s[1])*cos(s[0])),

    clean(s[2]*sin(s[1])*sin(s[0])),

    clean(s[2]*cos(s[1]))
    ];

    function sphu_from_cart(c, rad=1) = sph(
        atan2(c[1],c[0]),
        atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]),
        rad
        );

    tetra_cart = [
        [+1, +1, +1],
        [-1, -1, +1],
        [-1, +1, -1],
        [+1, -1, -1]
    ];

    function tetra_unit(rad=1) = [
        sph_to_cart(sphu_from_cart(tetra_cart[0], rad)),
        sph_to_cart(sphu_from_cart(tetra_cart[1], rad)),
        sph_to_cart(sphu_from_cart(tetra_cart[2], rad)),
        sph_to_cart(sphu_from_cart(tetra_cart[3], rad)),
        ];


    tetrafaces = [
        [0, 3, 1],
        [0,1,2],
        [2,1,3],
        [0,2,3]
    ];

    tetra_edges = [
        [0,1],
        [0,2],
        [0,3],
        [1,2],
        [1,3],
        [2,3],
        ];

    rotate([(180-dihedral_angle)/2, 0, 0])
    rotate([0, 0, 45])
    polyhedron(tetra_unit(rad), faces=tetrafaces);
}
//translate([0, 0, -17.7])
//cylinder(5,40,40);

function clean(n) = (n < 0) ? ((n < -Cepsilon) ? n : 0) :
    (n < Cepsilon) ? 0 : n;

function plat_dihedral(pq) = 2 * asin( cos(180/pq[1])/sin(180/pq[0]));

function plat_circumradius(pq, a) =
    (a/2)*
    tan(Cpi/pq[1])*
    tan(plat_dihedral(pq)/2);

function plat_midradius(pq, a) =
    (a/2)*
    cos(Cpi/pq[0])*
    tan(plat_dihedral(pq)/2);

function plat_inradius(pq,a) =
    a/(2*tan(Cpi/pq[0]))*
    sqrt((1-cos(plat_dihedral(pq)))/(1+cos(plat_dihedral(pq))));

function plat_a_from_inradius(pq, inradius) =
    inradius*(2*tan(Cpi/pq[0]))/
    sqrt((1-cos(plat_dihedral(pq)))/(1+cos(plat_dihedral(pq))));

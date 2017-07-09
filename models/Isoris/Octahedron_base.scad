// To use this file, copy && modify the header section
// then uncomment the needed parts.

////////////////////
//  HEADER START  //
////////////////////

// changelog
// v5
// - Nouvelle feuillure bouchon droit
_version = 5;

// arete = 39.783;
// epaisseurParoi = 1.5;
// r = 0.19; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
// offset_decoupe_bouchon = 0.42;
// bouchonOffset = 0.3;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
// decoupeZOffset = -r;

// You want to uncomment this...
// include <Octahedron_base.scad>;

//octahedron(arete);
//octa_creux();
//decoupe_bouchon();
// corps_ouvert();
// bouchon();
//trou();
// support();

////////////////////
//   HEADER END   //
////////////////////

octa_sch = [3,4];
Cpi = 3.14159;
Cphi = (1+sqrt(5))/2;
Cepsilon = 0.00000001;

include <../../lib/maths.scad>;

function octa_ext_radius(a) =
    a/2*(sqrt(2));

function octa_int_radius(a) =
    a/6*sqrt(6);

function octa_arete_from(radius) =
    radius*6/sqrt(6);

circumRadius = octa_ext_radius(arete);
internalRadius = octa_ext_radius(
                    octa_arete_from(
                        octa_int_radius(arete)-epaisseurParoi));
decoupe_bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 3) - offset_decoupe_bouchon,
              3);
bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 3) - offset_decoupe_bouchon - bouchonOffset,
              3);

echo(circumRadius=circumRadius);
echo(internalRadius=internalRadius);
echo(decoupe_bouchon_radius=decoupe_bouchon_radius);
echo(bouchon_radius=bouchon_radius);

module rotate_on_vertex() {
    rotate([0,plat_dihedral(octa_sch)/2,0]) children();
}

module support() {
    $fn=90;
    difference() {
        translate([0,0,-circumRadius*0.81])
            cylinder(circumRadius*0.42, r=circumRadius*0.4, center=true);
        translate([0,0,-circumRadius*0.9])
            cylinder(circumRadius, r=circumRadius*0.4-2, center=true);

        rotate_on_vertex() #octahedron(circumRadius);
        translate([0,0,-2*circumRadius*0.81])
            rotate_on_vertex() octahedron(circumRadius);

        // holes
        for (i=[1:4]) {
            rotate([0, 270, i*360/4+45]) translate([-circumRadius*0.81,0,-10])
                cylinder(h=20, r=4.6, center=true, $fn=4);
        }
    }
}

module corps_ouvert() {
    difference() {
        union() {
            octa_creux();
            // #feuillure(decoupe_bouchon_radius);
        }
        #decoupe_bouchon(decoupe_bouchon_radius, decoupeZOffset);
    }
}

module bouchon() {
    // rotate([180, 0, 0])
    difference () {
        intersection() {
            octa_creux();
            decoupe_bouchon(bouchon_radius);
        }
    }
}

module octa_creux() {
    difference() {
        octahedron(circumRadius);
        octahedron(internalRadius);
    }
}

module decoupe_bouchon(radius, zOffset = 0) {
  distance = octa_int_radius(arete)-epaisseurParoi+zOffset;
  rotate([0,0,60]) translate([0,0,distance])
    cylinder(epaisseurParoi+1, r=radius, $fn=3);
}

module feuillure(radius) {
  distance = octa_int_radius(arete)-epaisseurParoi-.8*epaisseurParoi;
  difference() {
    rotate([0,0,60]) translate([0,0,distance])
      cylinder(.8*epaisseurParoi, r=radius+.5*epaisseurParoi, $fn=3);
    rotate([0,0,60]) translate([0,0,distance])
      cylinder(.8*epaisseurParoi, r1=radius+.5*epaisseurParoi, r2=radius-1.2*epaisseurParoi, $fn=3);
  }
}


module octahedron(rad) {
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

    octa_cart = [
        [+1, 0, 0],  // + x axis
        [-1, 0, 0], // - x axis
        [0, +1, 0], // + y axis
        [0, -1, 0], // - y axis
        [0, 0, +1], // + z axis
        [0, 0, -1]  // - z axis
    ];

    function octa_unit(rad=1) = [
        sph_to_cart(sphu_from_cart(octa_cart[0], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[1], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[2], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[3], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[4], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[5], rad)),
        ];

    octafaces = [
        [4,2,0],
        [4,0,3],
        [4,3,1],
        [4,1,2],
        [5,0,2],
        [5,3,0],
        [5,1,3],
        [5,2,1]
        ];

    octa_edges = [
        [0,2],
        [0,3],
        [0,4],
        [0,5],
        [1,2],
        [1,3],
        [1,4],
        [1,5],
        [2,4],
        [2,5],
        [3,4],
        [3,5],
        ];

    function octahedron(rad=1) = [octa_unit(rad), octafaces, octa_edges];

    rotate([0, 90-plat_dihedral(octa_sch)/2, 0])
    rotate([45, 0, 0])
    polyhedron(octa_unit(rad), faces=octafaces);
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

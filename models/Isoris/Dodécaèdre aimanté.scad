magnetRadius = 2.6;
magnetHeight = 3.2 - 0.6;

include <../../lib/engineering_tools.scad>;

///////////////////////
// DODE
///////////////////////

// Uncomment only one of the 3 next variables.
// The 2 other will be automagically computed.
// _arete = 10;
_diameter = 60;
stellatedHeight = 29.3;
christiqueHeight = 11.26;
// _hauteurExt = 22.2703;

include <Dodecaedre_base.scad>;

r = 0.19; // résolution d'impression sur l'axe Z
epaisseurParoi = 1.5;
bottom_hole = 0; // on || off
bottom_hole_diameter = 1.6;
bouchon_hole = 0; // on || off
bouchon_hole_diameter = 1.6;
side_hole = 0; // on || off
side_hole_diameter = 1.6;

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 0.42;
bouchonOffset = 0.1; // 0.3 for Zortrax M200

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r;

// dode_creux();
// corps_ouvert();
rotate([180])
bouchon();
// bouchon_trou();
// bouchon_avec_attache();

///////////////////////////


dode_magnets();
// ico_vertex();
// vertex_magnet_cap();
// stellated_vertex();
// christique_vertex();

module stellated_vertex() {
    difference() {
        translate([0,0, hauteurExt/2]) rotate([0,0,-90])
            cylinder(h=stellatedHeight, r1=pentagon_circumradius(arete), r2=0, center=false, $fn=5);
        magnet_hole();
    }
}

module christique_vertex() {
    difference() {
        translate([0,0, hauteurExt/2]) rotate([0,0,-90])
            cylinder(h=christiqueHeight, r1=pentagon_circumradius(arete), r2=0, center=false, $fn=5);
        magnet_hole();
    }
}

module ico_vertex() {
    difference() {
        icosahedron(33);
        translate([0, 0,-hauteurExt])
        cylinder(h=3*hauteurExt, r=_diameter*2, center=true, $fn=10);
        magnet_hole();
    }
}

module magnet_hole() {
    // magnet hole
    translate([0, 0, hauteurExt/2+1.6+2*r])
        cylinder(h=magnetHeight, r=magnetRadius, center=false, $fn=20);
    // magnet cover hole
    translate([0, 0, hauteurExt/2-0.001])
        #cylinder(h=1.6+r, r=magnetRadius+1, center=false, $fn=20);
}

module vertex_magnet_cap() {
    // translate([0, 0, hauteurExt/2+0.84])
        cylinder(h=1, r=magnetRadius+1-0.1, center=true, $fn=20);
}


module dode_magnets() {
    // for (s = [0:1]) {
    //     for (i = [1:5]) {
    //         sign = s ? 1 : -1;
    //         rotate([0,0,i*72+s*36]) rotate([sign*(90-dihedral_angle)]) _dode_magnet();
    //     }
    // }
    rotate([-90,0]) _dode_magnet();
}

module _dode_magnet() {
    translate([0, hauteurInt/2-0.5])
        rotate([90, 0]) magnet_holder();
}

module magnet_holder() {
    difference() {
        cylinder(h=1.2, r1=magnetRadius+3, r2=magnetRadius+0.4, center=true, $fn=20);
        cylinder(h=3, r=magnetRadius, center=true, $fn=20);
        translate([0,15])
            cube(size=[magnetRadius*1.6,30,6], center=true);
    }
}



module icosahedron(rad=1) {
  Cphi = (1+sqrt(5))/2;

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
    ];

  icosa_faces = [
    [3,0,4],
    [3,4,9],
    [3,9,10],
    [3,10,7],
    [3,7,0],
    [0,8,4],
    [0,7,11],
    [0,11,8],
    [4,8,5],
    [4,5,9],
    [7,10,6],
    [7,6,11],
    [9,5,2],
    [9,2,10],
    [2,6,10],
    [1,5,8],
    [1,8,11],
    [1,11,6],
    [5,1,2],
    [2,1,6]
    ];

  rotate([0,0,36]) rotate([31.72, 0])
  polyhedron(icosa_unit(rad), faces = icosa_faces);
}

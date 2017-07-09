magnetRadius = 2.7;
magnetHeight = 3.1;

///////////////////
//   ICO START   //
///////////////////

// Uncomment only one of the 3 next variables.
// The 2 other will be automagically computed.
// _arete = 10;
_circumradius = 60;

include <Icosaedre_base.scad>;
include <../../lib/engineering_tools.scad>;

r = 0.19; // résolution d'impression sur l'axe Z
epaisseurParoi = 1.5;
bottom_hole = 0; // on || off
bottom_hole_diameter = 1.6;
side_hole = 0;

// distance entre la paroi extérieure et la découpe
// minimum. Printer specifics
offset_decoupe_bouchon = 0.35; // 0.2 pour M200
bouchonOffset = 0.1; // 0.3 pour zortrax
// TODO: bouchonThickness is not the real one: 0.8 gives full thickness
bouchonThickness = .6*epaisseurParoi;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r;

// ico_creux();
corps_ouvert();
// translate([0,0,3*r]) rotate([180])
// bouchon();

///////////////////////

// dode_vertex();
// tetra_vertex();

// magnet_cap();
ico_magnets();

module ico_magnets() {
    rotate([-90,0]) _ico_magnet();
    for (s = [0:1]) {
        sign = s ? 1 : -1;
        for (i = [1:3]) {
            rotate([0,0,i*360/3-30+60*s]) rotate([-sign*(90-dihedral_angle)])
                _ico_magnet();
        }
    }
    for (s = [0:1]) {
        sign = s ? 1 : -1;
        for (i = [1:3]) {
            rotate([0,0,i*360/3+8+s*60]) rotate([sign*(dihedral_angle2-1)])
                _ico_magnet();
        }
        for (i = [1:3]) {
            rotate([0,0,i*360/3+52+s*60]) rotate([sign*(dihedral_angle2-1)])
                _ico_magnet();
        }
    }
}

module _ico_magnet() {
    translate([0, inHeight-0.5])
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

module dode_vertex() {
    h = ico_inradius(arete);
    difference() {
        rotate([0,0,-30]) rotate([-37.4,0])
            dodecahedron(86.9);
        translate([0, 0,-h])
        cylinder(h=4*h, r=_circumradius*2, center=true, $fn=10);
        magnet_hole();
    }
}

module tetra_vertex() {
    h = ico_inradius(arete);
    difference() {
        rotate([0,0,-30]) translate([0,0,h])
            pyramid(side=arete);
        magnet_hole();
    }
}

module magnet_hole() {
    h = ico_inradius(arete);
    // magnet hole
    translate([0, 0, h+1.6+2*r])
        cylinder(h=magnetHeight-0.5, r=magnetRadius, center=false, $fn=30);
    // magnet cover hole
    translate([0, 0, h-0.001])
        cylinder(h=1.6+r, r=magnetRadius+1, center=false, $fn=20);
}

module magnet_cap() {
        cylinder(h=1, r=magnetRadius+1-0.1, center=true, $fn=20);
}

module dodecahedron(height) {
  scale([height,height,height]) {
    intersection() {
      cube([2,2,1], center = true);
      intersection_for(i=[0:4]) {
        rotate([0,0,72*i])
        rotate([116.565,0,0])
          cube([2,2,1], center = true);
      }
    }
  }
}

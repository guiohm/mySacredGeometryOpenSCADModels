arete = 33.257;
magnetRadius = 2.65;
magnetHeight = 3.1;

include <Octaedre_base.scad>;
include <../../lib/engineering_tools.scad>;

// cube_magnets();
// rotate([-90+plat_dihedral(octa_sch)/2]) rotate([0, 45])
// rotate([90])
// octa_vertex();
// vertex_magnet_cap();
kheops_vertex();
// dode_vertex();

module kheops_vertex() {
    difference() {
        translate([0,0,arete/2])
        pyramid(side=arete, square=true, centerHorizontal=true, centerVertical=false, kheops=true);
        // magnet hole
        translate([0,0,arete/2+1.6+2*r])
            cylinder(h=magnetHeight-0.5, r=magnetRadius, center=false, $fn=20);
        // magnet cover hole
        translate([0,0,arete/2-0.001])
            cylinder(h=1.6+r, r=magnetRadius+1, center=false, $fn=20);
    }
}

module dode_vertex() {
    difference() {
        rotate([-plat_dihedral([5,3])/2,0,0])
            dodecahedron(54.7);
        translate([0,0,-arete])
            cube(arete*3, center=true);
        // magnet hole
        translate([0,0,arete/2+1.6+2*r])
            cylinder(h=magnetHeight-0.5, r=magnetRadius, center=false, $fn=20);
        // magnet cover hole
        translate([0,0,arete/2-0.001])
            #cylinder(h=1.6+r, r=magnetRadius+1, center=false, $fn=20);
    }
}

module octa_vertex() {
    difference() {
        octahedron(octa_ext_radius(56.5)); // 33.3 / 16.8 / 49.
        translate([0, -arete])
            cube([100, 3*arete, 100], center=true);
        // magnet hole
        translate([0,arete/2+1.6+2*r])
            rotate([-90, 0])
            cylinder(h=magnetHeight-0.5, r=magnetRadius, center=false, $fn=20);
        // magnet cover hole
        translate([0,arete/2-0.001])
            rotate([-90, 0])
            #cylinder(h=1.6+r, r=magnetRadius+1, center=false, $fn=20);
    }
}

module vertex_magnet_cap() {
    // translate([0,0.525*arete])
    //     rotate([-90, 0])
        cylinder(h=1, r=magnetRadius+1-0.1, center=true, $fn=20);
}


module cube_magnets() {
    for (i = [1:4]) {
        rotate([0,0,i*90]) _cube_magnet();
    }
    rotate([-90,0]) _cube_magnet();
}

module _cube_magnet() {
    translate([0, arete*0.5-paroi-0.5])
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

//////////////////////
//  CUBE
//////////////////////


paroi = 1.5;
echelleReductionAjustementBouchon = 0.985;
r = 0.19; // résolution d'impression sur l'axe Z

// %cube_creux();
// cube(arete, center=true);
// decoupe_bouchon();
// cube_ouvert();
// bouchon();
//trou();



module cube_ouvert() {
    //rotate([180, 0, 0])
    difference() {
        cube_creux();
        #decoupe_bouchon();
    }
}

module bouchon() {
    translate([0,0,-arete/2+paroi/2])
        cube(size=[arete-1.6, arete-1.6, paroi], center=true);
}

module cube_creux() {
    difference() {
        cube(arete, center=true);
        cube(arete-2*paroi, center=true);
    }
}

module decoupe_bouchon(scale=1) {
    translate([0,0,arete/2-(paroi+r)/2+0.001])
        cube(size=[arete-1.4, arete-1.4, paroi+r], center=true);
    // rotate([0,0,45]) translate([0,0,arete/2*0.89+5*r])
    //     cylinder(6*r, r=arete*0.675, $fn=4);
    // rotate([0,0,45]) translate([0,0,arete/2*0.89])
    //     cylinder(6*r, r=(arete-paroi/2)*0.653, $fn=4);
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

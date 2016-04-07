r = 17.4/2;
rTrou = 4;
rayonCol = 1.5;
longueurCol= 20;
longueurEmbout = 25;
$fn=44;
angle = atan(325.81/(2*146.608));

use <../lib/rounded_primitives.scad>;

// Rotation pour placement sur les 3 embouts
rotate([0, 87, 0])

union() {
    difference() {
        union() {
            embouts();
            plateforme();
            sphere(r+rayonCol);
            // Faux raft pour maintien impression sans raft
            difference() {
                rotate([0, 93, 0])
                translate([0, 0, longueurEmbout+4.7])
                    cylinder(15, 22);
                rotate([0, 93, 0])
                translate([19, 0, longueurEmbout+4.7])
                    cube([30, 100, 10], center=true);
            }
        }
        // découpe base
        rotate([0, 93, 0])
        translate([0, 0, longueurEmbout+5])
            cylinder(15, 90, 90);
        // Découpe plateforme
        translate([-16, 0, -r-rayonCol+5.01])
            cylinder(3*r,16,20);
    }
}

module embouts() {
    rotate([0, 90, 45])
    embout();
    rotate([0, 90, -45])
    embout();
    rotate([0, angle, 0])
    embout();
}

module embout() {
    difference() {
        union() {
            rcylinder(h=longueurEmbout+longueurCol, r1=r, r2=r-0.1, b=1);
            cylinder(longueurCol, r+rayonCol, r+rayonCol);
        }
        union() {
//          translate([0, 0, longueurCol])
//              cylinder(longueurEmbout+1, rTrou, rTrou);
//          translate([-r/4,-30/2,longueurCol])
//              cube(size=[r/2, 30, 100], center=false);
        }
    }
}

module plateforme() {
    translate([-15, 0, -r-rayonCol])
        rcylinder(r1=25,r2=24,h=5,b=1);
}

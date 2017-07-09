// Entonnoir Remplissage Icosaèdre Sphère 40-50mm

radius = 21.036*0.55;
topRadius = 26;
height = 40;
epaisseur = 1;

include <../../lib/Morphology.scad>;

// rotate([180])
entonnoir();

module entonnoir_() {
    difference() {
        cylinder(h=height, r1=radius, r2=topRadius, $fn=3);
        translate([0,0,-0.01])
            cylinder(h=height+0.02, r1=radius-epaisseur, r2=topRadius-epaisseur, $fn=3);
    }
    intersection() {
        translate([0,0,-0.01])
            cylinder(h=height+0.02, r1=radius-epaisseur, r2=topRadius-epaisseur, $fn=3);
        translate([1.5,0]) rotate([0,22])
            cube(size=[1, 99, 99], center=true);
    }
}

module entonnoir() {
    base(1.001);
    translate([0,0,1])
    difference() {
        hull() {
            base(1);
            haut();
        }
        scale([0.83, 0.83, 1.01])
        hull() {
            base(1);
            haut(offset=3.5);
        }

    }
    // plateau
    difference() {
        // rotate([0,0,180]) translate([0,18, height-15])
            plateau();
        scale([0.83, 0.83, 1.01])
        hull() {
            base(1);
            haut(offset=3.5);
        }
    }

    // handle
    difference() {
        rotate([0,0,180]) translate([0,18, height-15])
            handle();
        scale([0.9, 0.9, 1.01])
        hull() {
            base(1);
            haut(offset=2);
        }
    }
}

module plateau() {
    difference() {
        translate([0,0,1])
        linear_extrude(height=3)
            minkowski(){
                translate([-radius*0.18, 0])
                square([radius, 2*radius], center=true);
                circle(2, $fn=20);
            }
    }
}

module handle() {
    // difference() {
        rotate([0,90])
        rotate_extrude(convexity = 10, $fn=40) {
            translate([10, 0]) circle(d=5);
            square([10, 1]);
        }
        // cube(size=[], center=false);
    // }
}

module haut(offset=0) {
    translate([0, 0, height])
    linear_extrude(height=1)
        shell(-1, center=false, $fn=44)
            circle(r=topRadius+offset);
}

module base(h) {
    linear_extrude(height=h)
    union() {
        shell(-0.9, center=false, $fn=22)
        intersection() {
            circle(r=radius, $fn=3);
            difference() {
                translate([-0.5*radius,0]) square(2*radius, center=true);
                // translate([-6+1.8,0]) square(12, center=true);
            }
        }
        // difference() {
        //     circle(r=radius, $fn=3);
        //     circle(r=radius-epaisseur, $fn=3);
        //     translate([6+2,0,0])
        //         square(12, center=true);
        // }
    }
}

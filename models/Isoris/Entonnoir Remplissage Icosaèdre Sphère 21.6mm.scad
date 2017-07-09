// Entonnoir Remplissage Icosaèdre Sphère 21.6mm

version = 2;

radius = 5.36;
topRadius = 26;
height = 40;
epaisseur = 1;

include <../../lib/Morphology.scad>;

rotate([180])
entonnoirV3();

// double entonnoir
module entonnoirV3() {
    difference() {
        union() {
            rotate([0,0,-120]) _entonnoirV3();
            translate([21, 0]) rotate([0,0,-120])
                _entonnoirV3();
        }
        rotate([0,0,-120]) interieur_entonnoir();
        translate([21, 0]) rotate([0,0,-120])
        interieur_entonnoir();
    }
    // Poignée
    rotate([0,0,-120])
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

module _entonnoirV3() {
    difference() {
        union() {
            base(1.001);
            translate([0,0,1]) scale([1.1, 1.1, 1])
            hull() {
                scale([1.2, 1.2, 1]) base(1);
                haut();
            }
            recouvrement_ico();
        }
        interieur_entonnoir();
        // debouche entrée air
        translate([4.7,0,0.6]) rotate([0,90, 90])
            cylinder(h=6, r=2, center=true, $fn=20);
        rotate([0,0,120])
        ico();

    }
}

module interieur_entonnoir() {
    translate([0,0,1]) scale([0.74, 0.74, 1.01])
    hull() {
        base(1);
        haut(offset=8);
    }
}

module recouvrement_ico() {
    hull() {
        translate([0,0,4]) scale([1.8, 1.8, 1]) base(1);
        translate([-2,0,-4])
            linear_extrude(height=1)
            rounding(r=2, $fn=15) square([12, 20], center=true);
    }
}

module ico() {
    s = 1.04;
    translate([0,0,-8.582+1]) rotate([0,0,180])
    scale([s,s,1])
    import("../../exports/Icosaèdre Sphère 21.6mm plein.stl");
}

module entonnoirV2() {
    base(1.001);
    translate([0,0,1])
    difference() {
        hull() {
            base(1);
            haut();
        }
        scale([0.74, 0.74, 1.01])
        hull() {
            base(1);
            haut(offset=8);
        }

    }
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

module handle() {
    // difference() {
        rotate([0,90])
        rotate_extrude(convexity = 10, $fn=40) {
            translate([12, 0]) circle(d=5);
            square([12, 1]);
        }
        // cube(size=[], center=false);
    // }
}

module haut(offset=0) {
    translate([0, 0, height])
    linear_extrude(height=1)
        shell(-0.7, center=false, $fn=44)
            circle(r=topRadius+offset);
}

module base(h) {
    linear_extrude(height=h)
    union() {
        shell(-0.7, center=false, $fn=22)
        intersection() {
            circle(r=radius, $fn=3);
            difference() {
                translate([-5+2.5,0]) square(10, center=true);
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


module entonnoirV1() {
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

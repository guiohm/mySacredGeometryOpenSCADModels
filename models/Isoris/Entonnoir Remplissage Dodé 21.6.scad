// Entonnoir Remplissage Icosaèdre Sphère 21.6mm

version = 2;

radius = 5.6663;
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
            _entonnoirV3();
            translate([21.2, 0])
                _entonnoirV3();
        }
        interieur_entonnoir(0.2);
        interieur_entonnoir(1);
        translate([21.2, 0]) {
            interieur_entonnoir(0.2);
            interieur_entonnoir(1);
        }
    }
    // Poignée
    rotate([0,0,-90])
    difference() {
        rotate([0,0,180]) translate([0,22, height-13.2])
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
            recouvrement_dode();
        }
        interieur_entonnoir(1);
        // debouche entrée air
        translate([0,-4.7,0.5]) rotate([0,90, 0])
            cylinder(h=6.5, r=2.3, center=true, $fn=20);
        dode();

    }
}

module interieur_entonnoir(d) {
    translate([0,0,d]) scale([0.74, 0.74, 1.01])
    hull() {
        base(1);
        haut(offset=8);
    }
}

module recouvrement_dode() {
    hull() {
        translate([0,0,5]) scale([1.7, 1.7, 1]) base(1);
        translate([0,2,-4])
            linear_extrude(height=1)
            rounding(r=2, $fn=15) square([20, 16], center=true);
    }
}

module dode() {
    s = 1.04;
    translate([0,0,-8.582+1]) //rotate([0,0,180])
    scale([s,s,1])
    import("../../exports/Dodécaèdre Sphère 21.6mm plein.stl");
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
        shell(-0.7, center=false, $fn=12)
        intersection() {
            rotate([0,0,-90]) circle(r=radius, $fn=5);
            difference() {
                translate([0,2]) square(10, center=true);
                // translate([-6+1.8,0]) square(12, center=true);
            }
        }
    }
}

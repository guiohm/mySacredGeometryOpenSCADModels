version = 5;

r = 8.7;
rTrou = 4;
rayonCol = 1.5;
longueurCol= 20;
longueurEmbout = 25;
$fn = 80;
angle = atan(325.81/(2*146.608));

include <../../lib/rounded_primitives.scad>;

// Rotation pour placement sur les 3 embouts
rotate([0, 87, 0])

connecteur();

module connecteur() {
    union() {
        difference() {
            union() {
                embouts();
                plateforme();
                sphere(r+rayonCol);
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
    union() {
        cylinder(longueurEmbout+longueurCol, r, r-0.1);
        cylinder(longueurCol, r+rayonCol, r+rayonCol);
    }
}

module plateforme() {
    translate([-15, 0, -r-rayonCol]) {
        // cylinder(5,25,25);
        rcylinder(r1=25, r2=25, h=5, b=1.5, center=false, fn=40, oneSide=true);
        renfort();
    }
}

module renfort() {
    h = 17;
    difference() {
        cylinder(h=h, r=25, center=false);
        translate([-10, 0]) rotate([0,9])
        cylinder(h=h+10, r=25, center=false);

        _renfort_decoupe();
        mirror([0,1]) _renfort_decoupe();

        translate([-28, 0])
        cube(size=50, center=true);
    }
}

module _renfort_decoupe() {
    translate([15, 42, 28])
    rotate([90, 0, -40])
    cylinder(h=40, r=23, center=false);
}

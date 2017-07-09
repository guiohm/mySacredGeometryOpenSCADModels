// r = 17.3/2; // Tube electrique d20
r = 5.4/2; // paille d6
rTrou = 4;
rayonCol = 0.6; // d20 -> 1.5
longueurCol= 8; // d20 -> 10.5
longueurEmbout = 7; // d20 -> 22
$fn=33;
roundingRadius = 0.5; // d20 -> 1
cubeDihedralAngle = 54.7 ;

use <../../lib/rounded_primitives.scad>;

// Rotation pour placement sur les 3 embouts

conn_corner = 1;
conn_center = 0;
conn_right_angle = 0;

rotate([0, 0, 0])
connector();

module connector() {
    union() {
        difference() {
            union() {
                if (conn_center) {
                    embouts_center();
                }
                if (conn_corner) {
                    embouts_corner();
                }
                if (conn_right_angle) {
                    embouts_right_angle();
                }
                sphere(r+rayonCol);
            }
            // k = conn_right_angle ? -1.66 : -1.55; // d20
            k = conn_right_angle ? -1.66 : -3.4;
            // découpe base
            translate([0, 0, k*longueurEmbout])
                cylinder(15, 90, 90);
        }
    }
}

module embouts_center() {
    embouts_corner();
    rotate([180,0,0]) embouts_corner();
}

module embouts_corner() {
    for (i = [1:3]) {
        rotate([0, 0, i*360/3])
        rotate([180-cubeDihedralAngle, 0, 0])
        embout();
    }
}

module embouts_right_angle() {
    rotate([180-45, 0, 0]) embout();
    rotate([180+45, 0, 0]) embout();
}

module embout() {
    difference() {
        union() {
            rcylinder(h=longueurEmbout+longueurCol, r1=r, r2=r-0.1, b=roundingRadius);
            cylinder(longueurCol, r+rayonCol, r+rayonCol);
        }
    }
}

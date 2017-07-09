version = 5;

r = 8.7;
rTrou = 4;
rayonCol = 1.5;
longueurCol= 20;
longueurEmbout = 30;
$fn=80;
angle = acos((2) / (sqrt(3)*sqrt(2)));
rayon_triangle = 48*(sqrt(3)/3); // 48 est l'arete du Tetraedre jeu 40

include <../../lib/rounded_primitives.scad>;

// Print time
// 0.19 solid high 2h11
// 0.29 solid high 1h39
//

// translate([0,-20])
// test();

// Rotation pour mise à plat
// rotate([-2*angle, 0, 0])

// Rotation pour placement sur les 3 embouts
rotate([180, 0, 0])

connecteur();

module connecteur() {
    union() {
        difference() {
            union() {
                embouts();
                sphere(r+rayonCol);
            }
            // découpe base
            translate([0, 0, longueurEmbout+8])
                cylinder(10, 50, 50);

            // Découpe plateforme
            translate([0, -3, -r-rayonCol-13.7])
            rotate([70, 0, 0])
             cylinder(4*r,22,26);
        }
        //cylinder(15, 25, 12);
    }
}

module embouts() {
    for (i = [1:3]) {
        rotate([0, 0, i*120])
        rotate([angle, 0, 0])
        embout(i);
    }
}

module embout(i) {
    union() {
        cylinder(longueurCol, r+rayonCol, r+rayonCol);
        translate([0, 0, longueurCol-0.2])
        cylinder(longueurEmbout, r, r-0.2);

        if (i == 3) {
            plateforme();
        }
    }
}

module plateforme() {
    rotate([angle, 0, 0]) translate([0,-19,-r-rayonCol]) {
        cylinder(5,25,25);

        // rotate_extrude(angle=360) {
        //     translate([23, 2])
        //     minkowski() {
        //         square([1,4]);
        //         circle(1, $fn=20);
        //     }
        // }
        renfort();
    }
}

module renfort() {
    h = 20;
    difference() {
        cylinder(h=h, r=25, center=false);
        translate([0,-10]) rotate([-9])
        cylinder(h=h+1, r=25, center=false);

        _renfort_coupe();
        mirror([1,0]) _renfort_coupe();

        translate([0,-22])
        cube(size=50, center=true);
    }
}

module _renfort_coupe() {
    translate([-35, 25, 28])
    rotate([90, 0, 30])
    cylinder(h=30, r=23, center=false);
}

module test() {
    cyslinder(1, d=pent_diam, $fn=5, center=true);
    translate([3.5,0,0]) rotate([0,0,0])
    #cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
    translate([1.6,0,0]) rotate([0,0,180])
    color("blue") cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
    translate([-2,1,0]) rotate([0,0,30])
    color("green") cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
    translate([-2,-1,0]) rotate([0,0,-30])
    color("magenta") cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
}

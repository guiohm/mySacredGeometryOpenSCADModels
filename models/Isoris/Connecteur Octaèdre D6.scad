r = 5.4/2;
rTrou = 4;
rayonCol = 0.4;
longueurCol= 5.6;
longueurEmbout = 7;
$fn=44;
angle = 45;

// Rotation pour mise à plat
//rotate([-2*angle, 0, 0])

// Rotation pour placement sur les 3 embouts
rotate([180, 0, 0])

union() {
    difference() {
        union() {
            embouts();
            sphere(r+rayonCol);
        }
        // découpe base
        translate([0, 0, r*3.2])
            cylinder(10, 50, 50);
    }
}

module embouts() {
    for (i = [1:4]) {
        rotate([0, 0, i*360/4])
        rotate([angle, 0, 0])
        embout(i);
    }
}

module embout(i) {
    difference() {
        union() {
            cylinder(longueurCol, r+rayonCol, r+rayonCol);
            translate([0, 0, longueurCol-0.2])
            cylinder(longueurEmbout, r, r-0.1);
        }
    }
}

r = 5.4/2;
rTrou = 4;
rayonCol = 0.4;
longueurCol= 5.5;
longueurEmbout = 7;
$fn=44;
angle = 90-31.7174744;

rotate([180, 0, 0])

union() {
    difference() {
        union() {
            embouts();
            sphere(r+rayonCol);
        }
        // découpe base
        translate([0, 0, r*2.8])
            cylinder(10, 50, 50);
    }
}

module embouts() {
    for (i = [1:5]) {
        rotate([0, 0, i*360/5])
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

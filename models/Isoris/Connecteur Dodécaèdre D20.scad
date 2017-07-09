// Connecteur Dodécaèdre D20

version = 2;

r = 17/2; // V1:17.4
rTrou = 4;
rayonCol = 1.5;
longueurCol= 8;
longueurEmbout = 25;
$fn=44;
// angle = 90-31.7174744;
// angle = 180-116.56;
angle = 68.72;
angleCube = -120*72/108;
echo(angleCube=angleCube);

rotate([180, 0, 0])

union() {
    difference() {
        union() {
            embouts();
            sphere(r+rayonCol);
        }
        // découpe base
        translate([0, 0, 0.44*(longueurCol+longueurEmbout)])
            cylinder(10, 50, 50);
    }
}

module embouts() {
    for (i = [1:3]) {
        rotate([0, 0, i*360/3])
        rotate([angle, 0, 0])
        embout(i);
        // rotate([0, 0, i*360/3+angleCube])
        // rotate([54.72, 0, 0])
        // embout(i);
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

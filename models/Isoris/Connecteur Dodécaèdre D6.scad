r = 5.35/2; // 5.35 pour Zortrax M200
rTrou = 4;
rayonCol = 0.4;
longueurCol= 2.8+6.5;
longueurEmbout = 8; //+2;
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
        translate([0, 0, 0.42*(longueurCol+longueurEmbout)])
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

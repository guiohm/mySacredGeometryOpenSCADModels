// Octaèdre Jeu sphère 33mm

// changelog
// v5
// - Bouchon droit
version = 5;

arete = 26.257;
epaisseurParoi = 1.35;
r = 0.19; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 0.42;
bouchonOffset = 0.4;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r;

include <Octahedron_base.scad>;

// octahedron(arete);
// octa_creux();
// decoupe_bouchon();
// corps_ouvert();
// bouchon();
// trou();
support();

module support() {
    $fn=90;
    difference() {
        translate([0,0,-circumRadius*0.81])
            cylinder(circumRadius*0.42, r=circumRadius*0.4, center=true);
        translate([0,0,-circumRadius*0.9])
            cylinder(circumRadius, r=circumRadius*0.4-1.6, center=true);

        rotate_on_vertex() #octahedron(circumRadius);
        translate([0,0,-2*circumRadius*0.81])
            rotate_on_vertex() octahedron(circumRadius);

        // holes
        for (i=[1:4]) {
            rotate([0, 270, i*360/4+45]) translate([-circumRadius*0.81,0,-10])
                cylinder(h=20, r=circumRadius*0.12, center=true, $fn=4);
        }

    }
}

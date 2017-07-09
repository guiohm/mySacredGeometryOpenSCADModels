// Rail assemblage pendentifs
longueur = 180;
largeur_base = 20;
largeur_haut = 14;
hauteur = 7;
largeur_fente = 1.4;
profondeur_fente = 4;

include <../../lib/engineering_tools.scad>;

difference(){
    rotate([90])
    linear_extrude(height=longueur, center=true) {
        minkowski(){
        polygon(points=[[-largeur_base/2,0], [largeur_base/2,0], [largeur_haut/2,hauteur],
            [largeur_fente/2, hauteur], [largeur_fente/2, hauteur-profondeur_fente], [-largeur_fente/2, hauteur-profondeur_fente], [-largeur_fente/2, hauteur],
            [-largeur_haut/2,hauteur]]);
        // circle(0.5);
        }
    }
    // translate([0,0,10-7/2+0.001])
    //     #cube(size=[1.7, longueur+1, 7], center=true);
}

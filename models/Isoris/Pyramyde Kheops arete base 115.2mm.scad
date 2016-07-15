arete = 115.2;
hauteur = 73.309;
paroi = 1.5;
biseau = 1; // boolean
echelleReductionAjustementBouchon = 0.99;
libEcho=false;

use <../lib/engineering_tools.scad>;

hauteurInterieure = hauteur - 3 * paroi;
areteInterieure = hauteurInterieure * arete / hauteur;

echo(areteInterieure);


//forme_creuse();
//decoupe_bouchon();
corps_ouvert();
// bouchon();


module corps_ouvert() {
    render(convexity=2)
    // rotate([180-51.8, 0, 0])
    difference() {
        forme_creuse();
        decoupe_bouchon();
    }
}

module bouchon() {
    render()
   // rotate([180, 0, 0])
    scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.99])
    difference () {
        intersection() {
            forme_creuse();
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
    }
}

module forme_creuse() {
    difference() {
        pyramid(side=arete, height=hauteur, square=true, centerHorizontal=true, centerVertical=true, kheops=true);
        pyramid(side=areteInterieure, height=hauteurInterieure, square=true, centerHorizontal=true, centerVertical=true, kheops=true);
    }
}

module decoupe_bouchon(scale=1) {
    distance = -hauteur/3;
    $fn=4;
    if (biseau) {
        rotate([0,0,45]) translate([0,0, distance])
            #cylinder(paroi, r=arete*0.688, r2=(arete-paroi)*0.67);
    } else {
        rotate([0,0,45]) translate([0,0, distance])
            cylinder(paroi, r=arete*0.65, center=true);
        rotate([0,0,45]) translate([0,0, distance+paroi/2])
            cylinder(paroi, r=(arete-paroi)*0.62, center=true);
    }
}

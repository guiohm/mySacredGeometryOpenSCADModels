// Grille remplissage formes

largeur = 200;
profondeur = 145;
epaisseurCadre = 15;
hauteurMontantCadre = 20;
largeurAttache = 30;
epaisseurRenfort = 3;

include <../../lib/Morphology.scad>;
include <../../lib/rounded_primitives.scad>;

// cadre();
// barre_grille();
// grille();
// attache_fond();
// translate([0,-40]) attache();
// rotate([-90])
// attache_oblong_pour_plot_tournant();

plot_tournant_pour_perceuse();

// attache_cables_electriques();

module attache_cables_electriques() {
    difference() {
        linear_extrude(height=5) {
            // $fn=33;
            rounding(r=5, $fn=33) square([18, 55]);
        }
        translate([4, 4]) cylinder(h=20, d=3.4, center=true, $fn=18);
        translate([14, 4]) cylinder(h=20, d=3.4, center=true, $fn=18);
        translate([3, 47]) cube(size=[2, 5, 20], center=true);
        translate([3, 33]) cube(size=[2, 5, 20], center=true);

    }
}

module plot_tournant_pour_perceuse() {
    diam_axe_mandrin = 12.5;
    diam_plot = 9.6;
    eccentrage = 1; // 3/2

    cylinder(h=30, d=diam_axe_mandrin, center=false, $fn=20);
    hull() {
    translate([0, 0, 29])
        cylinder(h=6, d=diam_axe_mandrin, center=false, $fn=20);
    translate([eccentrage, 0, 34])
        cylinder(h=6, d=diam_plot, center=false, $fn=20);
    }
    translate([eccentrage, 0, 39])
        cylinder(h=14, d=diam_plot, center=false, $fn=20);
}

module attache_oblong_pour_plot_tournant() {
    d = largeurAttache-2*epaisseurRenfort-2;
    difference() {
        hull() {
            linear_extrude(height=5) {
                rounding(r=5) square(largeurAttache);
            }
            translate([0, largeurAttache-5]) rotate([-90])
            linear_extrude(height=5) {
                rounding(r=5) square([largeurAttache,largeurAttache-4]);
            }
        }
        translate([d/2+epaisseurRenfort+1, d/2, -d])
            rcube(Size=[d,d,d*2],b=4);
        translate([largeurAttache/2, 7, -5]) cylinder(h=20, d=7);
        translate([largeurAttache/2-5.5, largeurAttache, -largeurAttache/2+4]) rotate([90, 90]) trou_oblong(d=10, longueur=11);
    }
}

module grille() {
    union() {
        cadre();
        barres();
        attache_fond();
        attache_droite();
        attache_gauche();
    }
}

module attache_gauche() {
    translate([-2, 45-largeurAttache]) rotate([0,0,90])
        attache();
}

module attache_droite() {
    translate([largeur+2, 45]) rotate([0,0,-90])
        attache();
}

module attache_fond() {
    translate([largeur/2-largeurAttache/2, profondeur+2])
        attache();
}

module attache() {
    difference() {
        union() {
           linear_extrude(height=5) {
                rounding(r=5) square(largeurAttache);
            }
            translate([largeurAttache-epaisseurRenfort, 0]) renfort_attache();
            renfort_attache();
        }
        translate([largeurAttache/2, 14]) trou_oblong();
    }
}

module renfort_attache() {
    hull() {
        cube(size=[epaisseurRenfort, largeurAttache-4, 4], center=false);
        cube(size=[epaisseurRenfort, 1, largeurAttache], center=false);
    }
}

module trou_oblong(d=7, longueur=7) {
    translate([0,0,-5])
    hull() {
        translate([0, longueur]) cylinder(h=20, d=d);
        cylinder(h=20, d=d);
    }
}

module cadre() {
    linear_extrude(height=hauteurMontantCadre+epaisseurCadre) {
        shell(d=4, center=false)
            rounding(r=5) square([largeur, profondeur]);
    }
}

module barres() {
    d = largeur/8;
    for (i = [1:7]) {
        translate([0 + i*d, 0]) barre_grille();
    }
}

module barre_grille() {
    translate([0,0,epaisseurCadre/2])
    scale([0.5, 1])
    rotate([0,-90, -90])
    cylinder(h=profondeur+2, r=epaisseurCadre, center=false, $fn=3);
}

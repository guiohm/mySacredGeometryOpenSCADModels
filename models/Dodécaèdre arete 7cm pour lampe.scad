hauteurExt = 155.894;
epaisseurParoi = 1.2;
diametreTrouBouchon = 1.6;
r = 0.19; // résolution d'impression sur l'axe Z
echelleReductionAjustementBouchon = 0.985;
hauteurInt = hauteurExt - 2 * epaisseurParoi;

use <../lib/maths.scad>;

// color("white")
corps_ouvert();
// color("black")
// piedE27();
// render(convexity=2)
// piedE27_grande_ampoule_1();
piedE27_grande_ampoule_2();
base_pied();
//piedE14();






// Modif : Ajout pentagone à coller sur les pieds déjà imprimés
//pentagone();
module pentagone() {
  distance = hauteurExt/2;
  epaisseur = 2;
  difference() {
    rotate([0,0,54]) translate([0,0,distance-4*epaisseur])
      cylinder(4, r=hauteurExt/2.65, $fn=5);
    rotate([0,0,54]) translate([0,0,distance-4*epaisseur])
      cylinder(4, r=hauteurExt/2.85, $fn=5);
  }
}

module corps_ouvert() {
	difference() {
		dode_creux();
		decoupe_bouchon();
	}
}

module piedE27() {
    pied(diamTrou=42);
}
module piedE27_grande_ampoule_1() {
    pied_grande_ampoule_1(diamTrou=42);
}
module piedE27_grande_ampoule_2() {
    pied_grande_ampoule_2(diamTrou=42);
}
module piedE14() {
    pied(diamTrou=30);
}

distance = hauteurExt/2;
epaisseur = 2;
module pied(diamTrou) {
    difference() {
        union() {
            pentagone_feuillure();
        }
        union() {
            trou_douille(diamTrou);
            ouvertures();
        }
    }

    // base pied
    difference() {
        rotate([0,0,54]) translate([0,0,distance])
            cylinder(60, r=30, r2=50, $fn=99);
        rotate([0,0,54]) translate([0,0,distance])
            cylinder(60, r=28.5, r2=48.5, $fn=99);
        // spirale1(distance);
        // spirale2(distance);
        // Passe fil
        translate([0,0,distance+50]) rotate([0,90,18])
            cylinder(120, r=3.5, $fn=20);
    }
}

module pied_grande_ampoule_1(diamTrou) {
    difference() {
        union() {
            pentagone_feuillure();

            // partie haute
            difference() {
                translate([0, 0, 220]) rotate([180])
                    parabolic_shell(43, 0.08, 24, 6);
                translate([0, 0, distance - 51])
                    cube(size=100, center=true);
                translate([0, 0, distance + 50 + 76])
                    cube(size=100, center=true);
            }
            // partie haute
            // rotate([0,0,54]) translate([0,0,distance])
            //     cylinder(75, r=43.5, r2=30, $fn=29);

            // partie basse
            difference() {
                translate([0, 0, 123])
                    parabolic_shell(50, 0.04, 24, 6);
                translate([0, 0, distance - 50 + 75])
                    cube(size=100, center=true);
                translate([0, 0, distance + 50 + 75 + 60])
                    cube(size=100, center=true);
            }
            // partie basse
            // rotate([0,0,54]) translate([0,0,distance+75])
            //     cylinder(60, r=30, r2=44, $fn=29);

            // plateforme douille
            translate([0,0, distance + 75])
                cylinder(h=3, d=60, $fn=20);
        }
        render(convexity=2)
        union() {
            translate([0,0,78])
                trou_douille(diamTrou);
            // ouverture ampoule
            trou_douille(84);

            // partie haute
            // rotate([0,0,54]) translate([0,0,distance])
            //     cylinder(75, r=42, r2=28.5, $fn=29);
            // partie basse
            // rotate([0,0,54]) translate([0,0,distance+75])
            //     cylinder(60, r=28.5, r2=42.5, $fn=29);
        }
        // spirale1(distance);
        // spirale2(distance);
        // Passe fil
        translate([0,0,distance+50+75]) rotate([0,90,18])
            cylinder(120, r=3.5, $fn=20);
    }
}

module pied_grande_ampoule_2(diamTrou) {
    difference() {
        union() {
            pentagone_feuillure();

            // partie haute
            rotate([0,0,0]) translate([0, 0, distance+35+25])
                linear_extrude(height = 72+50, twist = 40, scale = 0.44, center = true, slices = 50)
                    difference() {
                        offset(r=10, $fn=40) {
                            circle(d=69, $fn=10, center = true);
                        }
                        offset(r=9) {
                            circle(d=69, $fn=10, center = true);
                        }
                    }
            // partie haute
            // rotate([0,0,54]) translate([0,0,distance])
            //     cylinder(75, r=43.5, r2=30, $fn=29);

            // partie basse
            // rotate([0,0,54]) translate([0, 0, distance + 102])
            //     linear_extrude(height = 72, twist = 1*72, scale = 0.7, center = true, slices = 200)
            //         difference() {
            //             offset(r=10, $fn=80) {
            //                 circle(d=60*0.7, $fn=10, center = true);
            //             }
            //             offset(r=9) {
            //                 circle(d=60*0.7, $fn=10, center = true);
            //             }
            //         }
            // partie basse
            // rotate([0,0,54]) translate([0,0,distance+75])
            //     cylinder(60, r=30, r2=44, $fn=29);

            // plateforme douille
            translate([0,0, distance + 65]) rotate([0,0,51])
                cylinder(h=3, d=59, $fn=20);

        }
        render(convexity=2)
        union() {
            translate([0,0,68])
                trou_douille(diamTrou);
            // ouverture ampoule
            trou_douille(84);

            // partie haute
            // rotate([0,0,54]) translate([0,0,distance])
            //     cylinder(75, r=42, r2=28.5, $fn=29);
            // partie basse
            // rotate([0,0,54]) translate([0,0,distance+75])
            //     cylinder(60, r=28.5, r2=42.5, $fn=29);
        }
        // spirale1(distance);
        // spirale2(distance);
        // Passe fil
        translate([0,0,distance+40+65]) rotate([0,90,18])
            cylinder(120, r=3.5, $fn=20);

        // coupe en bas
        render(convexity=2)
        translate([0, 0, distance + 250 + 65 + 48])
            cube(size=500, center=true);
    }
}

module base_pied() {
    scale([1.01, 1.01])
    difference() {
        // base
        render(convexity=2)
        translate([0,0, distance + 65 + 48]) rotate([0,0,54+36])
            cylinder(h=4, r=hauteurExt/2.618*0.81, $fn=66, center=true);

        // trou
        render(convexity=2)
        translate([0,0, distance + 65 + 46]) rotate([0,0,36])
            cylinder(h=8, d=38, $fn=30, center=true);


        // trou decagone
        render(convexity=2)
        translate([0,0, distance + 65 + 46]) rotate([0,0,36])
            cylinder(h=4, d=43, $fn=10, center=true);

        pied_grande_ampoule_2();
    }
}

module spirale1(distance) {
    rotate([0,0,54]) translate([0, 0, distance+30])
        linear_extrude(height = 60, twist = 180, scale = 2, center = true, slices = 200)
            circle(d=55, $fn=5, center = true);
    rotate([0,0,54]) translate([0, 0, distance+30])
        linear_extrude(height = 60, twist = 180, scale = 2, center = true, slices = 200)
            circle(d=52, $fn=5, center = true);
}

module spirale2(distance) {
    rotate([0,0,54]) translate([0, 0, distance+30])
        linear_extrude(height = 60, twist = 1*72, scale = 2, center = true, slices = 200)
            difference() {
                offset(r=10, $fn=80) {
                    circle(d=36, $fn=5, center = true);
                }
                offset(r=9) {
                    circle(d=36, $fn=5, center = true);
                }
            }
}

module pentagone_feuillure() {
    // fermeture (face) dodécaèdre
    rotate([0,0,54]) translate([0,0,distance-epaisseur])
        cylinder(epaisseur, r=hauteurExt/2.565, r2=hauteurExt/2.618, $fn=5);
    // Feuillure
    rotate([0,0,54]) translate([0,0,distance-2*epaisseur])
        cylinder(epaisseur, r=hauteurExt/2.65, r2=hauteurExt/2.63, $fn=5);
}

module trou_douille(diamTrou) {
    rotate([0,0,54]) translate([0,0,distance-2*epaisseur])
        cylinder(2*epaisseur+0.2, r=diamTrou/2, $fn=50);
}

module ouvertures() {
    for (i = [1:5]) {
      rotate([0, 0, 360/5*i])
        translate([0, 0, distance-epaisseur-10]) rotate([0,0,0])
          decoupe_demi_cercle();
    }
}

//decoupe_demi_cercle();
module decoupe_demi_cercle() {
    translate([0,58,0])
    difference() {
      linear_extrude(height = 30)
        circle(28, $fn=55);
        translate([0,25,0])
        cube(80, center=true);
    }
}

module dode_creux() {
	difference() {
		dodecahedron(hauteurExt);
		dodecahedron(hauteurInt);
	}
}

module decoupe_bouchon() {
    distance = hauteurInt/2+4*r;
//	rotate([0,0,54]) translate([0,0,distance])
//		cylinder(epaisseurParoi, r=hauteurExt/2.675, $fn=5);
	rotate([0,0,54]) translate([0,0,hauteurExt/2-1.99])
		cylinder(2, r=hauteurExt/2.5, $fn=5);
}

module dodecahedron(height) {
	scale([height,height,height]) {
		intersection() {
			cube([2,2,1], center = true);
			intersection_for(i=[0:4]) {
				rotate([0,0,72*i])
				rotate([116.565,0,0])
					cube([2,2,1], center = true);
			}
		}
	}
}

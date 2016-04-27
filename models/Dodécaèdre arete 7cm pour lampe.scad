hauteurExt = 155.894;
epaisseurParoi = 1.2;
diametreTrouBouchon = 1.6;
r = 0.19; // résolution d'impression sur l'axe Z
echelleReductionAjustementBouchon = 0.985;
hauteurInt = hauteurExt - 2 * epaisseurParoi;

//dode_creux();
//decoupe_bouchon();
color("green")
//corps_ouvert();
//bouchon_avec_attache();
//bouchon();
//bouchon_trou();
color("gray")
piedE27();
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
module piedE14() {
    pied(diamTrou=30);
}

module pied(diamTrou) {
    distance = hauteurExt/2;
    epaisseur = 2;
    difference() {
        union() {
            // fermeture (face) dodécaèdre
            rotate([0,0,54]) translate([0,0,distance-epaisseur])
                cylinder(epaisseur, r=hauteurExt/2.565, r2=hauteurExt/2.618, $fn=5);
            // Feuillure
                rotate([0,0,54]) translate([0,0,distance-2*epaisseur])
                    cylinder(epaisseur, r=hauteurExt/2.65, r2=hauteurExt/2.63, $fn=5);
        }
        union() {
            // Trou douille
            rotate([0,0,54]) translate([0,0,distance-2*epaisseur])
                cylinder(2*epaisseur+0.2, r=diamTrou/2, $fn=50);
            // ouvertures
            for (i = [1:5]) {
              rotate([0, 0, 360/5*i])
                translate([0, 0, distance-epaisseur-10]) rotate([0,0,0])
                  decoupe_demi_cercle();
            }
        }
    }

    // base pied
    difference() {
        rotate([0,0,54]) translate([0,0,distance])
            cylinder(60, r=30, r2=50, $fn=99);
        rotate([0,0,54]) translate([0,0,distance])
            cylinder(60, r=28.5, r2=48.5, $fn=99);
        // spirale1(distance);
        spirale2(distance);
        // Passe fil
        translate([0,0,distance+50]) rotate([0,90,18])
            cylinder(120, r=3.5, $fn=20);
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

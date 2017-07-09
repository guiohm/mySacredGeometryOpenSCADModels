hauteurExt = 111.352;
epaisseurParoi = 1;
diametreTrouBouchon = 1.6;
facettesPied = 99;
r = 0.19; // résolution d'impression sur l'axe Z
echelleReductionAjustementBouchon = 0.985;
hauteurInt = hauteurExt - 2 * epaisseurParoi;
clipRadius = hauteurExt/2.67;
epaisseur = 1.5;

//dode_creux();
//decoupe_bouchon();
// corps_ouvert();
// piedE27();
//piedE14();

// Modif : Ajout pentagone à coller sur les pieds déjà imprimés
pentagone();
translate([0,0,8+0.16]) rotate([0,0,180]) rotate([180,0]) pentagone();
translate([0,0,8+2*0.16]) pentagone();
translate([0,0,16+3*0.16]) rotate([0,0,180]) rotate([180,0]) pentagone();
module pentagone() {
    distance = hauteurExt/2;
    hauteur = 4;
    rmax = clipRadius + 1.5;
    // translate([0,0,distance-2*epaisseur-hauteur])
    difference() {
        union() {
            rotate([0,0,54])
                cylinder(hauteur, r=clipRadius, $fn=5);
            // clip
            intersection() {
                rotate([0,0,54])
                    cylinder(hauteur*0.8, r1=clipRadius, r2=rmax, $fn=5);
                rotate([0,0,54+72/2])
                    cylinder(hauteur*0.8, r=clipRadius-5, $fn=5);
            }
            translate([0,0,hauteur*0.8])
            intersection() {
                rotate([0,0,54])
                    cylinder(hauteur*0.2, r1=rmax, r2=clipRadius+1, $fn=5);
                rotate([0,0,54+72/2])
                    cylinder(hauteur*0.2, r=clipRadius-5, $fn=5);
            }
        }
        rotate([0,0,54])
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
    difference() {
        union() {
            // fermeture (face) dodécaèdre
            rotate([0,0,54]) translate([0,0,distance-epaisseur])
                cylinder(epaisseur, r=hauteurExt/2.563, r2=hauteurExt/2.618, $fn=5);
            // Feuillure
                rotate([0,0,54]) translate([0,0,distance-2*epaisseur])
                    cylinder(epaisseur, r=hauteurExt/2.67, r2=hauteurExt/2.66, $fn=5);
            // clip
            translate([0,0,distance-2*epaisseur])
            intersection() {
                rotate([0,0,54])
                    cylinder(epaisseur, r1=clipRadius+1, r2=clipRadius+0.1, $fn=5);
                rotate([0,0,54+72/2])
                    cylinder(epaisseur, r=clipRadius-5, $fn=5);
            }
        }
        union() {
            // Trou douille
            rotate([0,0,54]) translate([0,0,distance-2*epaisseur])
                cylinder(2*epaisseur+0.2, r=diamTrou/2, $fn=50);
            // ouvertures
//            for (i = [1:5]) {
//              rotate([0, 0, 360/5*i])
//                translate([0, 0, distance-epaisseur-10]) rotate([0,0,0])
//                  decoupe_demi_cercle();
//            }
        }
    }

    // base pied
    difference() {
        dhaut = 50;
        dbas = 88;
        rotate([0,0,54]) translate([0,0,distance])
            cylinder(56, d1=dhaut, d2=dbas, $fn=facettesPied);
        rotate([0,0,54]) translate([0,0,distance])
            cylinder(56, d1=dhaut-3, d2=dbas-3, $fn=facettesPied);
        // Passe fil
        translate([0,0,distance+48]) rotate([0,90,18])
            cylinder(120, r=3.5, $fn=20);
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
	rotate([0,0,54]) translate([0,0,hauteurExt/2-epaisseur+0])
		cylinder(epaisseur+0.01, r=hauteurExt/2.5, $fn=5);
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

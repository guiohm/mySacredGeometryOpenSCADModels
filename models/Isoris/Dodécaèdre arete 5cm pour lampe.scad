hauteurExt = 111.352;
epaisseurParoi = 1;
diametreTrouBouchon = 1.6;
facettesPied = 99;
r = 0.19; // résolution d'impression sur l'axe Z
echelleReductionAjustementBouchon = 0.985;
hauteurInt = hauteurExt - 2 * epaisseurParoi;

//dode_creux();
//decoupe_bouchon();
corps_ouvert();
//piedE27();
//piedE14();

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
                cylinder(epaisseur, r=hauteurExt/2.542, r2=hauteurExt/2.618, $fn=5);
            // Feuillure
                rotate([0,0,54]) translate([0,0,distance-2*epaisseur])
                    cylinder(epaisseur, r=hauteurExt/2.65, r2=hauteurExt/2.64, $fn=5);
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
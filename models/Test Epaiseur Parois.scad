hauteurExt = 155.894;
epaisseurParoi = 1;
diametreTrouBouchon = 1.6;
r = 0.19; // résolution d'impression sur l'axe Z
echelleReductionAjustementBouchon = 0.985;
hauteurInt = hauteurExt - 2 * epaisseurParoi;

//dode_creux();
//decoupe_bouchon();
//corps_ouvert();
//bouchon_avec_attache();
//bouchon();
//bouchon_trou();
//piedE27();
//testParois();

module testParois() {
    rayon = 10;
    paroi = 1.2;
    difference() {
        $fn=70;
        cylinder(10, r=rayon, center=true);
        cylinder(11, r=rayon-paroi, center=true);   
    }
}

module corps_ouvert() {
	difference() {
		dode_creux();
		decoupe_bouchon();
	}
}

module bouchon_avec_attache() {
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.995])
	union () {
		intersection() {
			dode_creux();
			decoupe_bouchon();
		}
		translate([0, 0, hauteurExt/2])
		rotate([90, 0, 54])
		rotate_extrude(convexity = 10, $fn=40)
		translate([1, 0, 0])
		circle(r = 0.5, $fn=40);
	}
}

module bouchon_trou() {
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 1])
	difference () {
		intersection() {
			dode_creux();
			decoupe_bouchon();
		}
		translate([0, 0, hauteurExt/2.5])
		cylinder(30, r=diametreTrouBouchon/2, $fn=22);
	}
}

module bouchon() {
    //rotate([0,180,0])
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 1])
	difference () {
		intersection() {
			dode_creux();
			decoupe_bouchon();
		}
	}
}

module piedE27() {
    distance = hauteurExt/2;
    epaisseur = 2;
	rotate([0,0,54]) translate([0,0,distance-2])
		cylinder(epaisseur, r=hauteurExt/2.565, r2=hauteurExt/2.618, $fn=5);
    
    // Feuillure
	rotate([0,0,54]) translate([0,0,distance-2])
		cylinder(epaisseur, r=hauteurExt/2.565, r2=hauteurExt/2.618, $fn=5);
    
    rotate([0,0,54]) translate([0,0,distance+epaisseur*2])
		cylinder(60, r=30, r2=50, $fn=80);
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
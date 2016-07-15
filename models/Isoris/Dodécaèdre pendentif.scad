hauteurExt = 19.071; // équivalent sphère circonscrite 24 mm
epaisseurParoi = 1.5;
diametreTrouBouchon = 2;
r = 0.19; // résolution d'impression sur l'axe Z
echelleReductionAjustementBouchon = 0.93;

//corps_ouvert();
//bouchon_avec_attache();
rotate([180, 0, 0])
bouchon_trou();

module corps_ouvert() {
	difference() {
		dode_creux();
		decoupe_bouchon();
	}
}

module bouchon_avec_attache() {
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 1])
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

module dode_creux() {
	difference() {
		dodecahedron(hauteurExt);
		dodecahedron(hauteurExt - 2 * epaisseurParoi);
	}
}

module decoupe_bouchon() {
	rotate([0,0,54]) translate([0,0,hauteurExt/2.5+5*r])
		cylinder(6*r, r=hauteurExt/2.8, $fn=5);
	rotate([0,0,54]) translate([0,0,hauteurExt/2.5])
		cylinder(6*r, r=hauteurExt/2.42-epaisseurParoi, $fn=5);
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
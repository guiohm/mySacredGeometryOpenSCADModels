arete = 39.908;
paroi = 1.5;
echelleReductionAjustementBouchon = 0.972;
r = 0.19; // résolution d'impression sur l'axe Z

//cube_creux();
//decoupe_bouchon();
//corps_ouvert();
bouchon();
//trou();

module corps_ouvert() {
    //rotate([180, 0, 0])
	difference() {
		cube_creux();
		decoupe_bouchon();
	}
}

module bouchon() {
    rotate([180, 0, 0])
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.995])
	difference () {
        intersection() {
            cube_creux();
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
	}
}

module cube_creux() {
	difference() {
        cube(arete, center=true);
        cube(arete-2*paroi, center=true);
	}
}

module decoupe_bouchon(scale=1) {
    distance = arete/2;
	rotate([0,0,45]) translate([0,0,distance])
		cylinder(paroi, r=arete*0.682, $fn=4, center=true);
	rotate([0,0,45]) translate([0,0,distance-paroi])
		cylinder(paroi, r=(arete-paroi/2)*0.666, $fn=4, center=true);
}



arete = 28.868;
paroi = 1.5;
echelleReductionAjustementBouchon = 0.985;
r = 0.19; // résolution d'impression sur l'axe Z

//ico_creux();
//decoupe_bouchon();
corps_ouvert();
//bouchon();
//trou();

module corps_ouvert() {
    //rotate([180, 0, 0])
	difference() {
		cube_creux();
		decoupe_bouchon();
	}
}

module bouchon() {
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
	rotate([0,0,45]) translate([0,0,arete/2*0.87+5*r])
		cylinder(6*r, r=arete*0.67, $fn=4);
	rotate([0,0,45]) translate([0,0,arete/2*0.87])
		cylinder(6*r, r=(arete-paroi/2)*0.653, $fn=4);
}



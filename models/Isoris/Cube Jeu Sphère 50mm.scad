// Cube Jeu Sphère 50mm

// changelog
// v5
// - Bouchon droit
version = 5;

arete = 33.257;
epaisseurParoi = 1.5;
r = 0.29; // résolution d'impression sur l'axe Z

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 0.84;
bouchonOffset = 0.3;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r/2;

//decoupe_bouchon();
corps_ouvert();
// bouchon();
//trou();

module corps_ouvert() {
	difference() {
		cube_creux();
		#decoupe_bouchon(offset_decoupe_bouchon, decoupeZOffset);
	}
}

module bouchon() {
	difference () {
        intersection() {
            cube_creux();
            decoupe_bouchon(offset_decoupe_bouchon+bouchonOffset);
        }
	}
}

module cube_creux() {
	difference() {
        cube(arete, center=true);
        cube(arete-2*epaisseurParoi, center=true);
	}
}

module decoupe_bouchon(d, zOffset = 0) {
    a = arete - 2*d;
	translate([0,0,arete/2+((epaisseurParoi+1)/2)-epaisseurParoi+zOffset])
		cube([a, a, epaisseurParoi+1], center=true);
}



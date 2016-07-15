angle = 20.905;
externalRadius = 12;
internalRdius = 10.113; // Pour épaisseur paroi 1.5 mm
diametreTrouBouchon = 1.5;
echelleReductionAjustementBouchon = 0.93;
r = 0.19; // résolution d'impression sur l'axe Z

//ico_creux();
//decoupe_bouchon();
//corps_ouvert();
bouchon_trou();
//trou();

module corps_ouvert() {
    //rotate([180, 0, 0])
	difference() {
		ico_creux();
		decoupe_bouchon();
        trou();
	}
}

module bouchon_trou(version) {
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.98])
	difference () {
        intersection() {
            ico_creux();
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
        trou();
        // trou centre face
//		translate([0, 0, externalRadius*0.5])
//		cylinder(30, r=diametreTrouBouchon/2, $fn=22);
	}
}

module trou() {
    rotate([0, -37.3, 0])
		translate([0, 0, externalRadius*0.5])
		cylinder(30, r=diametreTrouBouchon/2, $fn=22);
}

module ico_creux() {
	difference() {
        rotate([0, angle, 0]) icosahedron(externalRadius);
        rotate([0, angle, 0]) icosahedron(internalRdius);
	}
}

module decoupe_bouchon(scale=1) {
	rotate([0,0,60]) translate([0,0,externalRadius*0.65+5*r])
		cylinder(6*r, r=externalRadius*0.56, $fn=3);
	rotate([0,0,60]) translate([0,0,externalRadius*0.65])
		cylinder(6*r, r=internalRdius*0.6, $fn=3);
}

module icosahedron(rad=1) {
	Cphi = (1+sqrt(5))/2;

	// Convert spherical to cartesian
	function sph_to_cart(c, rad) = [
		rad*sin(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))*cos(atan2(c[1],c[0])),  
		rad*sin(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))*sin(atan2(c[1],c[0])),
		rad*cos(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))
		];


	//================================================
	//	Icosahedron
	//================================================
	//
	// (0, +-1, +-Cphi)
	// (+-Cphi, 0, +-1)
	// (+-1, +-Cphi, 0)

	function icosa_unit(rad) = [
		sph_to_cart([0, +1, +Cphi], rad), 
		sph_to_cart([0, +1, -Cphi], rad),
		sph_to_cart([0, -1, -Cphi], rad),
		sph_to_cart([0, -1, +Cphi], rad),
		sph_to_cart([+Cphi, 0, +1], rad), 
		sph_to_cart([+Cphi, 0, -1], rad), 
		sph_to_cart([-Cphi, 0, -1], rad),
		sph_to_cart([-Cphi, 0, +1], rad),
		sph_to_cart([+1, +Cphi, 0], rad),
		sph_to_cart([+1, -Cphi, 0], rad), 
		sph_to_cart([-1, -Cphi, 0], rad), 
		sph_to_cart([-1, +Cphi, 0], rad),
		];

	icosa_faces = [ 
		[3,0,4],
		[3,4,9],
		[3,9,10],
		[3,10,7],
		[3,7,0],
		[0,8,4],
		[0,7,11],
		[0,11,8],
		[4,8,5],
		[4,5,9],
		[7,10,6],
		[7,6,11],
		[9,5,2],
		[9,2,10],
		[2,6,10],
		[1,5,8],
		[1,8,11],
		[1,11,6],
		[5,1,2],
		[2,1,6]
		];

	polyhedron(icosa_unit(rad), faces = icosa_faces);
}


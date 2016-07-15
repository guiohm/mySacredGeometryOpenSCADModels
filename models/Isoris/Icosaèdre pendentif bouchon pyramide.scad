angle = 31.72;
externalRadius = 12;
internalRdius = 10.113; // Pour épaisseur paroi 1.5 mm
diametreTrouBouchon = 1.5;
echelleReductionAjustementBouchon = 0.95;
r = 0.19; // résolution d'impression sur l'axe Z


//corps_ouvert();
bouchon_trou(1);

module corps_ouvert() {
    rotate([180, 0, 0])
	difference() {
		ico_creux();
		decoupe_bouchon();
	}
}

module bouchon_trou(version) {
	//scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 1])
	difference () {
        union() {
            intersection() {
                ico_creux();
                decoupe_bouchon(echelleReductionAjustementBouchon);
            }
            // Partie de feuillure manquante
            difference() {
               rotate([0,0,18]) translate([0,0,externalRadius/2.718-r])
                cylinder(7*r, internalRdius*0.91*echelleReductionAjustementBouchon, internalRdius*0.93*echelleReductionAjustementBouchon, $fn=5);
               rotate([0,0,18]) translate([0,0,externalRadius/2.718-2*r])
                cylinder(8*r, r=internalRdius*0.7, $fn=5);
            }
        }
        if (version == 1) {
            translate([0, 0, externalRadius/2.718])
            cylinder(30, r=diametreTrouBouchon/2, $fn=22);
        } else {
            translate([0, 0, externalRadius*0.82])
            rotate([90, 0, 0])
            cylinder(60, r=diametreTrouBouchon/2, $fn=22, center=true);
        }
	}
}

module ico_creux() {
	difference() {
        rotate([-angle, 0, 0]) icosahedron(externalRadius);
        rotate([-angle, 0, 0]) icosahedron(internalRdius);
	}
}

module decoupe_bouchon(scale=1) {
	rotate([0,0,18]) translate([0,0,externalRadius/2.718+5*r])
		cylinder(60*r, r=externalRadius*0.9, $fn=5);
	rotate([0,0,18]) translate([0,0,externalRadius/2.718-r])
		cylinder(7*r, internalRdius*0.91*scale, internalRdius*0.93*scale, $fn=5);
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


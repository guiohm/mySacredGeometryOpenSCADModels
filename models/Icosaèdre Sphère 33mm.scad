arete = 17.349;
angle = 20.905;
paroi = 1.5;
echelleReductionAjustementBouchon = 0.935;
r = 0.19; // résolution d'impression sur l'axe Z
ico_sch = [3,5];
Cpi = 3.14159;
Cphi = (1+sqrt(5))/2;
Cepsilon = 0.00000001;

function ico_ext_radius(a) = 
    a*1/4*(sqrt(10+2*sqrt(5)));
    
function ico_int_radius(a) = 
    a/12*(3*sqrt(3)+sqrt(15));
    
function ico_arete_from(int_radius) = 
    int_radius*12/(3*sqrt(3)+sqrt(15));
    
externalRadius = ico_ext_radius(arete);
internalRadius = ico_ext_radius( 
                    ico_arete_from(
                        ico_int_radius(arete)-paroi));
                        
echo(externalRadius); 
echo(internalRadius);

//ico_creux();
//decoupe_bouchon();
corps_ouvert();
//bouchon();
//trou();

module corps_ouvert() {
    //rotate([180, 0, 0])
	difference() {
		ico_creux();
		decoupe_bouchon();
	}
}

module bouchon(version) {
    //rotate([180, 0, 0])
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.98])
	difference () {
        intersection() {
            ico_creux();
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
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
        rotate([0, angle, 0]) icosahedron(internalRadius);
	}
}

module decoupe_bouchon(scale=1) {
    distance = ico_int_radius(arete);
	rotate([0,0,60]) translate([0, 0, distance])
		cylinder(paroi, r=arete*0.544, $fn=3, center=true);
	rotate([0,0,60]) translate([0, 0, distance-paroi])
		cylinder(paroi, r=(arete-paroi)*0.555, $fn=3, center=true);
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


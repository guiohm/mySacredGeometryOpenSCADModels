arete = 66.836;
paroi = 1.5;
echelleReductionAjustementBouchon = 0.985;
r = 0.19; // résolution d'impression sur l'axe Z
octa_sch = [3,4];
Cpi = 3.14159;
Cphi = (1+sqrt(5))/2;
Cepsilon = 0.00000001;

function octa_ext_radius(a) =
    a/2*(sqrt(2));

function octa_int_radius(a) =
    a/6*sqrt(6);

function octa_arete_from(radius) =
    radius*6/sqrt(6);

circumRadius = octa_ext_radius(arete);
internalRadius = octa_ext_radius(
                    octa_arete_from(
                        octa_int_radius(arete)-paroi));

echo(circumRadius=circumRadius);
echo(internalRadius=internalRadius);
echo(dihedral=plat_dihedral(octa_sch));

//octahedron(arete);
//octa_creux();
//decoupe_bouchon();
// corps_ouvert();
// bouchon();
//trou();
support();

module rotate_on_vertex() {
    rotate([0,plat_dihedral(octa_sch)/2,0]) children();
}

module support() {
    $fn=90;
    difference() {
        translate([0,0,-circumradius*0.885])
        cylinder(circumradius*0.27, r=circumradius*0.4, center=true);
        translate([0,0,-circumradius*0.9])
        cylinder(circumradius, r=circumradius*0.4-2, center=true);
        rotate_on_vertex() octahedron(circumRadius);
    }
}

module corps_ouvert() {
	difference() {
		octa_creux();
		decoupe_bouchon();
	}
}

module bouchon() {
//    rotate([180, 0, 0])
	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.995])
	difference () {
        intersection() {
            octa_creux();
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
	}
}

module octa_creux() {
	difference() {
        octahedron(circumRadius);
        octahedron(internalRadius);
	}
}

module decoupe_bouchon(scale=1) {
    distance = octa_int_radius(arete);
	rotate([0,0,60]) translate([0,0, distance])
		cylinder(paroi, r=arete*0.56, $fn=3, center=true);
	rotate([0,0,60]) translate([0,0, distance-paroi])
		cylinder(paroi, r=(arete-paroi)*0.551, $fn=3, center=true);
}


module octahedron(rad) {
    // create an instance of a spherical coordinate
    // long - rotation around z -axis
    // lat - latitude, starting at 0 == 'north pole'
    // rad - distance from center
    function sph(long, lat, rad=1) = [long, lat, rad];

    // Convert spherical to cartesian
    function sph_to_cart(s) = [
	clean(s[2]*sin(s[1])*cos(s[0])),

	clean(s[2]*sin(s[1])*sin(s[0])),

	clean(s[2]*cos(s[1]))
	];

    function sphu_from_cart(c, rad=1) = sph(
        atan2(c[1],c[0]),
        atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]),
        rad
        );

    octa_cart = [
        [+1, 0, 0],  // + x axis
        [-1, 0, 0],	// - x axis
        [0, +1, 0],	// + y axis
        [0, -1, 0],	// - y axis
        [0, 0, +1],	// + z axis
        [0, 0, -1] 	// - z axis
    ];

    function octa_unit(rad=1) = [
        sph_to_cart(sphu_from_cart(octa_cart[0], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[1], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[2], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[3], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[4], rad)),
        sph_to_cart(sphu_from_cart(octa_cart[5], rad)),
        ];

    octafaces = [
        [4,2,0],
        [4,0,3],
        [4,3,1],
        [4,1,2],
        [5,0,2],
        [5,3,0],
        [5,1,3],
        [5,2,1]
        ];

    octa_edges = [
        [0,2],
        [0,3],
        [0,4],
        [0,5],
        [1,2],
        [1,3],
        [1,4],
        [1,5],
        [2,4],
        [2,5],
        [3,4],
        [3,5],
        ];

    function octahedron(rad=1) = [octa_unit(rad), octafaces, octa_edges];

    rotate([0, 90-plat_dihedral(octa_sch)/2, 0])
    rotate([45, 0, 0])
    polyhedron(octa_unit(rad), faces=octafaces);
}
//translate([0, 0, -17.7])
//cylinder(5,40,40);

function clean(n) = (n < 0) ? ((n < -Cepsilon) ? n : 0) :
	(n < Cepsilon) ? 0 : n;

function plat_dihedral(pq) = 2 * asin( cos(180/pq[1])/sin(180/pq[0]));

function plat_circumradius(pq, a) =
	(a/2)*
	tan(Cpi/pq[1])*
	tan(plat_dihedral(pq)/2);

function plat_midradius(pq, a) =
	(a/2)*
	cos(Cpi/pq[0])*
	tan(plat_dihedral(pq)/2);

function plat_inradius(pq,a) =
	a/(2*tan(Cpi/pq[0]))*
	sqrt((1-cos(plat_dihedral(pq)))/(1+cos(plat_dihedral(pq))));

function plat_a_from_inradius(pq, inradius) =
    inradius*(2*tan(Cpi/pq[0]))/
	sqrt((1-cos(plat_dihedral(pq)))/(1+cos(plat_dihedral(pq))));

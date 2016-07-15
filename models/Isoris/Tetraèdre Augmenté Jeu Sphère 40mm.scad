arete = 49;
paroi = 1.5;
echelleReductionAjustementBouchon = 0.97;
r = 0.19; // résolution d'impression sur l'axe Z
tetra_sch = [3,3];
Cpi = 3.14159;
Cphi = (1+sqrt(5))/2;
Cepsilon = 0.00000001;

function tetra_ext_radius(a) = 
    a/4*sqrt(6);
    
function tetra_int_radius(a) = 
    a/12*sqrt(6);
    
function tetra_arete_from_int(radius) = 
    radius*12/sqrt(6);
    
function tetra_arete_from_ext(radius) = 
    radius*4/sqrt(6);
    
externalRadius = tetra_ext_radius(arete);
internalRadius = tetra_ext_radius( 
                    tetra_arete_from_int(
                        tetra_int_radius(arete)-paroi));
                        
echo(externalRadius); 
echo(internalRadius);

render(convexity = 2)
//merkaba(arete);
//poly_creux();
//decoupe_bouchon();
corps_ouvert();
bouchon();
//trou();

module corps_ouvert() {
//    rotate([180, 0, 0])
	difference() {
		poly_creux();
		decoupe_bouchon();
	}
}

module bouchon() {
//	scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.995])
	difference () {
        intersection() {
            union() {
                poly_creux();
                supplement_feuillure_bouchon(echelleReductionAjustementBouchon);
            }
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
	}
}

module poly_creux() {
	difference() {
        stellated_tetrahedron(externalRadius);
        stellated_tetrahedron(internalRadius);
	}
}

module decoupe_bouchon(scale=1) {
    distance = tetra_int_radius(arete);
    scale2 = pow(scale,4);
    prof_ratio = 1.4*scale2;
	rotate([0,0,60]) translate([0,0,distance+0.0])
		cylinder(999, r=arete*0.6, $fn=3);
	rotate([0,0,60]) translate([0,0,distance-(prof_ratio*paroi+0.01)*scale2])
		cylinder((prof_ratio*paroi+0.01)*scale2, r=(arete-paroi)*0.55*scale, $fn=3, center=false);
}

module supplement_feuillure_bouchon(scale=1) {
    distance = tetra_int_radius(arete);
    radius = (arete-paroi)*scale*0.55;
    rotate([0,0,60]) translate([0,0, distance-paroi])
    difference() {   
		cylinder(paroi*pow(scale,3), r=radius, $fn=3, center=false);
		cylinder(paroi*pow(scale,3), r=radius-2.5, $fn=3, center=false);
    }
}

module stellated_tetrahedron(rad) {
    distance = 2*tetra_int_radius(tetra_arete_from_ext(rad));
    union() {
        tetrahedron(rad);
        translate([0, 0, distance]) rotate([0,180,60]) tetrahedron(rad);
        for (i = [1:3]) {
            rotate([0,-acos(1/3),360/3*i]) translate([0, 0, -distance]) tetrahedron(rad);
        }
    }
}

module tetrahedron(rad) {
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

    tetra_cart = [
        [+1, +1, +1],
        [-1, -1, +1],
        [-1, +1, -1],
        [+1, -1, -1]
    ];

    function tetra_unit(rad=1) = [
        sph_to_cart(sphu_from_cart(tetra_cart[0], rad)), 
        sph_to_cart(sphu_from_cart(tetra_cart[1], rad)),
        sph_to_cart(sphu_from_cart(tetra_cart[2], rad)),
        sph_to_cart(sphu_from_cart(tetra_cart[3], rad)),
        ];


    tetrafaces = [
        [0, 3, 1],
        [0,1,2],
        [2,1,3],
        [0,2,3]
    ];

    tetra_edges = [
        [0,1],
        [0,2],
        [0,3], 
        [1,2], 
        [1,3], 
        [2,3],	
        ];

    rotate([0, (180-acos(1/3))/2, 0])
    rotate([0, 0, 45])
//    rotate(a=(180-acos(1/3))/2, v=[1,1,0])
    polyhedron(tetra_unit(rad), faces=tetrafaces);
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
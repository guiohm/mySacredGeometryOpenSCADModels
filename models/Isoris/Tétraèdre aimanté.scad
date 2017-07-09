magnetRadius = 2.65;
magnetHeight = 3.1;

arete = 73.515; // jeu sphère 60mm
paroi = 1.5;
echelleReductionAjustementBouchon = 0.99;
r = 0.19; // résolution d'impression sur l'axe Z
tetra_sch = [3,3];
Cpi = 3.14159;
Cphi = (1+sqrt(5))/2;
Cepsilon = 0.00000001;

function tetra_ext_radius(a) =
    a/4*sqrt(6);

function tetra_int_radius(a) =
    a/12*sqrt(6);

function tetra_arete_from(radius) =
    radius*12/sqrt(6);

externalRadius = tetra_ext_radius(arete);
internalRadius = tetra_ext_radius(
                    tetra_arete_from(
                        tetra_int_radius(arete)-paroi));

echo(externalRadius);
echo(internalRadius);

//decoupe_bouchon();
// rotate([180])
// tetra_creux();

// rotate([plat_dihedral(tetra_sch)+180])
// corps_ouvert();

// bouchon();
//trou();

// tetra_magnets();

// rotate([plat_dihedral(tetra_sch)+180])
tetra_pointe();

module tetra_pointe() {
    h = tetra_int_radius(arete);
    difference() {
        tetrahedron(externalRadius);
        translate([0, 0, -arete/2+h])
            cylinder(h=arete, r=arete, center=true, $fn=20);
        // magnet hole
        translate([0, 0, h+1.6+2*r])
            cylinder(h=magnetHeight-0.5, r=magnetRadius, center=false, $fn=20);
        // magnet cover hole
        translate([0, 0, h-0.001])
            cylinder(h=1.6+r, r=magnetRadius+1, center=false, $fn=20);
    }
}

module tetra_pointe_magnet_cap() {
        cylinder(h=1.6, r=magnetRadius+1-0.1, center=true, $fn=20);
}

module tetra_magnets() {
    // for (i = [0:1]) {
    //     rotate([0,0,60-i*120]) rotate([90-plat_dihedral(tetra_sch)])
    //         _tetra_magnet();
    // }
    rotate([0,0,180]) rotate([-90]) _tetra_magnet();
}


module _tetra_magnet() {
    translate([0, tetra_int_radius(arete)-paroi-0.5])
        rotate([90, 0]) magnet_holder();
}

module magnet_holder() {
    difference() {
        cylinder(h=1.2, r1=magnetRadius+3, r2=magnetRadius+0.4, center=true, $fn=20);
        cylinder(h=3, r=magnetRadius, center=true, $fn=20);
        translate([0,15])
            cube(size=[magnetRadius*1.6,30,6], center=true);
    }
}


module corps_ouvert() {
    difference() {
        tetra_creux();
        decoupe_bouchon();
    }
}

module bouchon() {
//    rotate([180, 0, 0])
    scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.95])
    difference () {
        intersection() {
            tetra_creux();
            decoupe_bouchon(echelleReductionAjustementBouchon);
        }
    }
}

module tetra_creux() {
    difference() {
        tetrahedron(externalRadius);
        tetrahedron(internalRadius);
    }
}

module decoupe_bouchon(scale=1) {
    distance = tetra_int_radius(arete);
    rotate([0,0,30]) translate([0,0,-distance-2*r])
        cylinder(6*r, r=arete*0.548, $fn=3);
    rotate([0,0,30]) translate([0,0,-distance])
        cylinder(8*r, r=(arete-paroi)*0.529, $fn=3);
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

    rotate([54.735, 0, 0])
    rotate([0, 0, 45])
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

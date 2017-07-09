a = 28.1; // arete cube
areteOcta = 39.783; // sphère 50mm;
magnetRadius = 2.65;
magnetHeight = 3;
echelleReductionAjustementBouchon = 0.992;

include <Octaedre_base.scad>;
include <../../lib/engineering_tools.scad>;

// octa();
// rotate([90,0])
// cube_vertex();
// vertex_magnet_cap();
// magnet_holder();
// rotate([0,plat_dihedral([3,4])])
// tetra_vertex();

module tetra_vertex() {
    h = octa_int_radius(arete);
    difference() {
        translate([0,0,h]) rotate([0,0,90])
        pyramid(side=areteOcta);
        // magnet hole
        translate([0,0,h+1.6+2*r])
            cylinder(h=magnetHeight-0.5, r=magnetRadius, center=false, $fn=20);
        // magnet cover hole
        translate([0,0,h-0.001])
            cylinder(h=1.6+r, r=magnetRadius+1, center=false, $fn=20);
    }
}

module cube_vertex() {
    h = octa_int_radius(arete);
    difference() {
        rotate([0,35.3]) rotate([45])
        cube(size=a, center=true);
            translate([0,0,-h])
            cylinder(h=4*h, r=a, center=true, $fn=12);
        // magnet hole
            translate([0,0,h+0.8+2*r])
            cylinder(h=magnetHeight-0.2, r=magnetRadius-0.4, center=false, $fn=20);
            translate([0,0,h+0.8+2*r])
            cylinder(h=magnetHeight-0.3-2*r, r=magnetRadius, center=false, $fn=20);
        // magnet cover hole
            translate([0,0,h-0.001])
            cylinder(h=0.8+r, r=magnetRadius+0.96, center=false, $fn=20);
    }
}

module vertex_magnet_cap() {
    // rotate([plat_dihedral(octa_sch)/2, 0, 45])
    //     translate([0,0,0.6*a])
            cylinder(h=0.6, r=magnetRadius+1-0.1, center=true, $fn=20);
}

module octa() {
    arete = areteOcta;
    paroi = 1.5;
    echelleReductionAjustementBouchon = 0.985;
    r = 0.19; // résolution d'impression sur l'axe Z

    //octahedron(arete);
    rotate_flat()
    octa_creux();
    //decoupe_bouchon();
    // corps_ouvert();
    // rotate([180])
    // bouchon();
    //trou();


    // #octa_magnets(arete);

    module octa_magnets(arete) {
        // for (s = [0:1]) {
        //     for (i = [1:3]) {
        //         sign = s ? 1 : -1;
        //         rotate([0, 0, 360/3*i-sign*30]) rotate([sign*(90-plat_dihedral(octa_sch))])
        //             _octa_magnet();
        //     }
        // }
        // rotate([90, 0]) _octa_magnet();
        rotate([-90, 0]) _octa_magnet();
    }

    module _octa_magnet() {
        translate([0, arete*0.356])
            rotate([90, 0]) magnet_holder();
    }

}

module magnet_holder() {
    difference() {
        cylinder(h=1.2, r1=magnetRadius+3, r2=magnetRadius+0.4, center=true, $fn=20);
        cylinder(h=3, r=magnetRadius, center=true, $fn=20);
        translate([0,15])
            cube(size=[magnetRadius*1.6,30,6], center=true);
    }
}

_arete = 43;

include <Dodecaedre_base.scad>;

epaisseurParoi = 4;
pent_diam = 2*pentagon_circumradius(arete);
rayon_triangle = 48*(sqrt(3)/3); // 48 est l'arete du Tetraedre jeu 40

echo(pent_diam=pent_diam);


// translate([0,0,4])
// test();
main();

module main() {
    rotate([0,-90,0])
    union() {
        coupelle_base();
        wall_mount();
        gussets();
    }
}

module coupelle_base() {
    difference() {
        translate([0,0,hauteurExt/2]) rotate([0,0,-90])
        dode_creux();
        translate([0,0,7]) rotate([0,0,0])
        cylinder(100, d=500, $fn=5, center=false);
    }
}

module wall_mount() {
    difference() {
        translate([-pent_diam*0.398,0,18]) rotate([0,-90,0])
        cylinder(h=epaisseurParoi, d1=pent_diam*.928, d2=pent_diam*.96, $fn=5, center=false);
        translate([-pent_diam*0.398,0,38]) rotate([0,-90,0])
            #cylinder(d=4.8, h=10, $fn=22, center=true);
    }
}

module gussets() {
    difference() {
        union() {
            gusset();
            translate([0,18,0]) gusset();
            translate([0,-18,0]) gusset();
        }
        translate([0,0,1])
            cylinder(r=100, h=20);
    }
}

module gusset() {
    translate([-pent_diam*.32,0,0.9]) rotate([90,0,0])
    cylinder(r=12, h=3, $fn=3,center=true);
}



module test() {
    // cylinder(1, d=pent_diam, $fn=5, center=true);
    translate([3.5,0,0]) rotate([0,0,0])
    #cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
    translate([1.6,0,0]) rotate([0,0,180])
    color("blue") cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
    translate([-2,1,0]) rotate([0,0,30])
    color("green") cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
    translate([-2,-1,0]) rotate([0,0,-30])
    color("magenta") cylinder(1.1
        , r=rayon_triangle, $fn=3, center=true);
}

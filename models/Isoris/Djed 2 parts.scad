paroi = 1.5;
diametreTrouPlot = 1.1;
echelleAjustementBouchon = 0.98;
$fn=44;

// djed_creux();
// djed_ouvert();
// demi_djed_ouvert();
bouchon();

module demi_djed_ouvert() {
    // rotate([90,0])
    union() {
        djed_ouvert(180);
        plots();
    }
}

module djed_ouvert(angle) {
    difference() {
        djed_creux(angle);
        decoupe_bouchon();
    }
}

module bouchon() {
    intersection() {
        djed_creux();
        decoupe_bouchon(echelleAjustementBouchon, 0.86);
    }
}

module decoupe_bouchon(scale=1, zscale=1) {
    translate([0,0, -160/2-15.2])
        scale([scale, scale, zscale])
        cylinder(h=paroi+0.2, r=27.8, center=false, $fn=66);
}

module djed_creux(angle=360) {
    difference() {
        rotate_extrude(angle=angle, convexity = 10)
            // translate([0,0])
            difference() {
                sketch();
                // r: rounded, delta: straight
                offset(r=-paroi) {
                    sketch();
                }
            }
        translate([0,0,-15])
        cylinder(r=paroi*paroi, h=160-2*paroi, center=true);
    }
}

module plots() {
    translate([-15.4, 0, 62.7]) plot();
    translate([15.4, 0, 62.7]) plot();
    translate([26.3, 0, -91.6]) plot();
    translate([-26.3, 0, -91.6]) plot();
}

module plot() {
    translate([0, 5/2]) rotate([90,0,0])
    difference() {
        cylinder(h=5, r=1, r2=1.8, center=true, $fn=20);
        translate([0,0,2.1])
        cylinder(h=3, r=diametreTrouPlot/2, center=true, $fn=20);
    }
}

// sketch();
module sketch() {
    import(file = "Djed_v1.dxf");
}

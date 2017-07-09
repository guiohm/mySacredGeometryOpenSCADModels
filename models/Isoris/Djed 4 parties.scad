// Djed 4 parties

version = 1;
height = 36;
paroi = 1.5;
$fn=44;

// djed_creux();
// translate([0,0,-2])
// djed_base();
translate([0,0,-2])
ailette();
ailette2();

module ailette2() {
    d = 27.6;
    difference() {
        union() {
            djed_creux();
            translate([0,0,d])
                renfort(0.98);
        }
        translate([0,0,d])
            #decoupe(0.5);
        ailette(0.2);
    }
}

module ailette(offset=0) {
    d = 9.27;
    difference() {
        union() {
            djed_creux();
            translate([0,0,d])
                renfort(0.6+offset);
        }
        translate([0,0,d])
            decoupe(0.5+offset);
        // djed_base();
    }
}

module djed_base() {
    difference() {
        union() {
            djed_creux();
            translate([0,0,-9.05])
                renfort();
        }
        translate([0,0,-9.05]) decoupe();
    }
}

module renfort(offset=0) {
    difference() {
        cylinder(h=paroi, r=35/2-paroi/2+offset, center=false);
        translate([0,0,-0.01])
        cylinder(h=paroi+0.1, r=35/2-paroi+offset, center=false);
    }
}

module decoupe(offset=0) {
    difference() {
        cylinder(h=666, r=666, center=false, $fn=12);
        cylinder(h=2, r=35/2-paroi/2+offset, center=false);
    }
}

module djed_creux(angle=36, fn=20) {
    difference() {
        rotate_extrude(angle=angle, convexity = 10)
            // translate([0,0])
            difference() {
                sketch();
                // r: rounded, delta: straight
                offset(r=-paroi, $fn=fn, chamfer=false) {
                    sketch();
                }
            }
        translate([0,0,-15])
        cylinder(r=paroi*paroi, h=160-2*paroi, center=true);
    }
}

// sketch();
module sketch() {
    import(file = "../Djed_v2.dxf");
}

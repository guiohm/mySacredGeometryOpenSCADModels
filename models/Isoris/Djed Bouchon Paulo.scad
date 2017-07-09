// Djed Bouchon Paulo

diamExterieur = 18;
diamInterieur = 15;
hauteur = 12;
diamBase = 26;
epaisseurBase = 2;
epaisseurGravure = 0.2;

include <../../lib/rounded_primitives.scad>;

e = 0.01;
$fn = 36;


bouchon();

// gravure_Svastika(sens=2);

module gravure_Svastika(sens="dextro") {
    translate([0,0,-e])
    scale([0.3, 0.3])
    if (sens == "dextro") {
        mirror([1, 0, 0]) Svastika();
    } else {
        Svastika();
    }
}

module Svastika() {
    ep = 2; // demi-epaisseur
    h = 24; // hauteur
    l = h/1.618; // longueur "ailettes"

    linear_extrude(height=0.3)
    polygon([[l, h], [-ep, h], [-ep, ep], [-h+2*ep, ep],
    [-h+2*ep, l], [-h, l], [-h, -ep], [-ep, -ep],
    [-ep, -h+2*ep], [-l, -h+2*ep], [-l, -h], [ep, -h],
    [ep, -ep], [h-2*ep, -ep], [h-2*ep, -l], [h, -l],
    [h, ep], [ep, ep], [ep, h-2*ep], [l, h-2*ep], [l, h]]);
}

module gravure_Djed() {
    translate([0,1, -1+epaisseurGravure])
    scale(0.1, 0.1, 1) {
        linear_extrude(height=10) {
            mirror([1,0,0])
            sketch();
            sketch();
        }
    }
}

module sketch() {
        translate([-2, 0])
        import(file = "../Djed_v1.dxf");
}

module bouchon() {
    difference() {
        union() {
            cylinder(h=epaisseurBase, d=diamBase, center=false);
            translate([0, 0, epaisseurBase-e])
            rcylinder(r1=diamExterieur/2, r2=diamExterieur/2, h=hauteur, b=1, center=false, fn=20, oneSide=true);
            // cylinder(h=hauteur+epaisseurBase, d=diamExterieur, center=false);
        }
        translate([0,0, epaisseurBase+1])
            cylinder(h=hauteur+1, d=diamInterieur, center=false);
        for (i= [1:2]) {
        rotate([0,0,i*180]) translate([diamBase/2, 0, -0.6])
            cylinder(h=epaisseurBase+1, r=(diamBase-diamExterieur)/2, center=false);
        }
        // gravure_Djed();
        gravure_Svastika(sens="dextr");
    }
}

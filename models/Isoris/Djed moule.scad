// Djed moule
version = 2; // 7.8 / 7.3

hauteur = 55;
margeMoule = 22;
hauteurPlotCentrage = 10;
dCylindreEvac = 4;

$fn=200;

// djed_creux();
// djed_ouvert();
// demi_djed_ouvert();
// bouchon();
rotate([90])
moule();

module moule(type="male") {
    difference() {
        // cylinder(h=hauteur+margeMoule, r=22, center=true, $fn=20);
        cube(size=[hauteur*0.37+margeMoule, hauteur*0.37+margeMoule, hauteur+margeMoule], center=true);
        //coupe
        translate([-hauteur, 0, -hauteur])
            cube(size=2*hauteur, center=false);

        translate([0,0,hauteur*0.08])
            djed(h=hauteur);

        // Evacuation
        translate([0,0,hauteur*0.48])
        cylinder(h=0.25*hauteur, d1=dCylindreEvac, d2=dCylindreEvac*3, center=false, $fn=44);
        translate([0,0,-hauteur*0.63])
        cylinder(h=0.25*hauteur, d2=dCylindreEvac, d1=dCylindreEvac*3, center=true, $fn=44);

        if (type != "male") {
            plots_centrage();
        }
    }
    if (type == "male") {
        plots_centrage(type);
    }
}

module plots_centrage(type) {
    translate([hauteur*0.26, 0, hauteur*0.55])
        _plot_centrage(type);
    translate([-hauteur*0.26, 0, hauteur*0.55])
        _plot_centrage(type);
    translate([hauteur*0.26, 0, -hauteur*0.3])
        _plot_centrage(type);
    translate([-hauteur*0.26, 0, -hauteur*0.3])
        _plot_centrage(type);
}

module _plot_centrage(type) {
    angle = type == "male" ? -90 : 90;
    d = type == "male" ? 0.1 : 0;
    translate([0, -d])
    rotate([angle]) rotate([0,0,45])
    cylinder(h=hauteurPlotCentrage, d1=9, d2=4, center=false, $fn=4);
}

module djed(h=160, angle=360) {
    s = h/160;
    scale([s, s, s])
    rotate_extrude(angle=angle, convexity = 10)
        sketch();
}


// sketch();
module sketch() {
    import(file = "../Djed_v1.dxf");
}

r = 8.65;
rTrou = 4;
rayonCol = 1.5;
longueurCol= 8;
longueurEmbout = 25;
$fn=80;
angle = acos(1/(2*sin(180/5)));

// Rotation pour placement sur les 3 embouts
rotate([0, 0, 0])

union() {
	difference() {
		union() {
			embouts();
//			plateforme();
            sphere(r+rayonCol);
		}
		// découpe base
		rotate([0, 85, 0])
		translate([0, 0, longueurEmbout-3])
			cylinder(15, 90, 90);
		// Découpe plateforme
//		translate([-20, 0, -r-rayonCol+3.01])
//			cylinder(3*r,16,20);
	}
}

module embouts() {
	rotate([0, 90, 108/2])
	embout();
	rotate([0, 90, -108/2])
	embout();
//	rotate([0, angle, 0])
//	embout();
}

module embout() {
	difference() {
		union() {
			cylinder(longueurEmbout+longueurCol, r, r-0.1);
			cylinder(longueurCol, r+rayonCol, r+rayonCol);
		}
		union() {
//			translate([0, 0, longueurCol])
//				cylinder(longueurEmbout+1, rTrou, rTrou);
//			translate([-r/4,-30/2,longueurCol])
//				cube(size=[r/2, 30, 100], center=false);
		}
	}
}

module plateforme() {
    translate([-16, 0, -r-rayonCol],$fn=5)
        rotate([0, 0, 36])
			cylinder(3,27,26);
}
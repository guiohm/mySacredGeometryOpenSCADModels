r = 8.7;
rTrou = 4;
rayonCol = 1.5;
longueurCol= 20;
longueurEmbout = 30;
$fn=70;
angle = acos((2) / (sqrt(3)*sqrt(2)));

// Rotation pour mise à plat
//rotate([-2*angle, 0, 0])

// Rotation pour placement sur les 3 embouts
rotate([180, 0, 0])

union() {
	difference() {
		union() {
			embouts();
            sphere(r+rayonCol);
		}
		// découpe base
		translate([0, 0, longueurEmbout+8])
			cylinder(10, 50, 50);
        
        
        
		// Découpe plateforme
		translate([0, 0, -r-rayonCol-10])
        rotate([70, 0, 0])
			cylinder(4*r,16,20);	
	}
	//cylinder(15, 25, 12);
}

module embouts() {
	for (i = [1:3]) {
		rotate([0, 0, i*120])
		rotate([angle, 0, 0])
		embout(i);
	}
}

module embout(i) {
	difference() {
		union() {
			cylinder(longueurCol, r+rayonCol, r+rayonCol);
            translate([0, 0, longueurCol-0.2])
			cylinder(longueurEmbout, r, r-0.2);
		}
		union() {
//			translate([0, 0, longueurCol])
//				cylinder(longueurEmbout+1, rTrou, rTrou);
//			translate([-r/4,-30/2,longueurCol])
//				cube(size=[r/2, 30, 100], center=false);
		}
	}

	if (i == 3) {
		plateforme();
	}
}

module plateforme() {
	rotate([angle, 0, 0])
		translate([0,-19,-r-rayonCol])
			cylinder(3,25,24);
}
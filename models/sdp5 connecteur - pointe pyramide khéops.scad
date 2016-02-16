r = 8.7;
rTrou = 4;
rayonCol = 1.5;
longueurCol= 20;
longueurEmbout = 25;
$fn=80;

union() {
	difference() {
		union() {
			embouts();
		}		
        translate([0, 0, -r])
			cylinder(12, 50, 50);
		// découpe base
		translate([0, 0, longueurEmbout+6])
			cylinder(10, 50, 50);	
	}
    translate([0, 0, r/3])
        cylinder(10, 20, r);
    translate([0, 0, r/3])
        cylinder(2, 25, 24);
	//translate([0, 0, 2])
//		cylinder(15, 25, 12);
}
echo(atan(325.81/(2*146.608)));
module embouts() {
	for (i = [1:4]) {
		rotate([0, 0, i*360/4])
		rotate([atan(325.81/(2*146.608)), 0, 0])
		embout();
	}
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
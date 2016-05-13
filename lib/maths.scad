pi = 3.14159265358979;


////// PARABOLAS //////

//Standard parabola
function parabolaPoint(x, k) = k * x * x;

//Focal point equals Y where derivative of parabolaPoint is 1.
function focal_length(k) = parabolaPoint(0.5 / k, k);

//Cup shape
module outer_parabola(width, k, segments, base_thickness = 1) {
    for(i = [-segments:1:segments - 1]) {
        x1 = i * width / segments;
        x2 = (i + 1) * width / segments;
        polygon([[x1, -base_thickness], [x1, parabolaPoint(x1, k)],
            [x2, parabolaPoint(x2, k)], [x2, -base_thickness]],
            [[3, 2, 1, 0]]);
    }
}

//Bulge shape
module inner_parabola(width, k, segments) {
    assign(max_y = parabolaPoint(width, k))
    for(i = [-segments:1:segments - 1]) {
        x1 = i * width / segments;
        x2 = (i + 1) * width / segments;
        polygon([[x1, max_y], [x1, parabolaPoint(x1, k)],
            [x2, parabolaPoint(x2, k)], [x2, max_y]],
            [[0, 1, 2, 3]]);
    }
}

module parabolic_trough (length, width, k, segments) {
    rotate([90, 0, 90])
    linear_extrude(length, $fn = segments * 4)
    outer_parabola(width, k, segments);
}

module parabolic_dish (width, k, segments) {
    rotate_extrude($fn = segments * 4)
    intersection() {
        outer_parabola(width, k, segments);
        translate([0, -1])
        square([width + 1, parabolaPoint(width, k) + 2]);
    }
}

module parabolic_shell (width, k, segments, thickness) {
    rotate_extrude($fn = segments * 4)
    difference() {
        intersection() {
            outer_parabola(width, k, segments);
            translate([0, -1])
            square([width + 1, parabolaPoint(width, k) + 2]);
        }
        translate([0, -thickness])
        intersection() {
            outer_parabola(width, k, segments);
            translate([0, -1])
            square([width + 1, parabolaPoint(width, k) + 2]);
        }
    }
}

////////////////////////////////

// linear_extrude(1) outer_parabola(10, 0.2, segments = 20);

// color("green")
// linear_extrude(0.5) inner_parabola(10, 0.2, segments = 20);

// echo(str("Focal length = ", focal_length(0.2)));
// color("white")
// translate([0, focal_length(0.2)])
// cylinder(r = 0.25, $fn=20);

// translate([-10, 32, 0])
// parabolic_trough(20, 10, 0.1, 5);

// translate([0, 54, 0])
// parabolic_dish(10, 0.05, 5);

///////////////////////
//// END PARABOLAS ////
///////////////////////


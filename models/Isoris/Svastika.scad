segmentLength = 22; // total height 40mm
segmentWidth = 4;
roundRadius = 1;

distance = segmentLength - segmentWidth/2 - 2*roundRadius;

use <../lib/rounded_primitives.scad>;

// svastika_1();
// svastika_2(); // with infinite
svastika_3(); // With 18 segments

module svastika_1() {
    union() {
        $fn = 20;
        rotate([-90, 0, 0])
            branch("left", "Orange", "Red", "DeepPink");
        rotate([90, 180, 0])
            branch("right", "yellow", "GreenYellow", "green");
        rotate([180, 0, 90])
            branch("right", "DodgerBlue", "Cyan", "MediumAquamarine");
        rotate([0, 0, -90])
            branch("left", "DarkBlue", "Purple", "Magenta");
    }
}

module svastika_2() {
    union() {
        $fn = 20;
        rotate([0, 0, 0])
            branch("left", "Orange", "Red", "DeepPink");
        rotate([0, 180, 0])
            branch("right", "yellow", "GreenYellow", "green");
        rotate([180, 0, 90])
            branch("right", "DodgerBlue", "Cyan", "MediumAquamarine");
        rotate([0, 0, -90])
            branch("left", "DarkBlue", "Purple", "Magenta");
    }
}

module svastika_3() {
    union() {
        $fn = 20;
        rotate([-90, 0, 0])
            branch("left", "Orange", "Red", "DeepPink");
        rotate([90, 180, 0])
            branch("right", "yellow", "GreenYellow", "green");
        rotate([180, 0, 90])
            branch("right", "DodgerBlue", "Cyan", "MediumAquamarine");
        rotate([0, 0, -90])
            branch("left", "DarkBlue", "Purple", "Magenta");
        rotate([0, -90, -90])
            branch("left");
        rotate([0, 90, -90])
            branch("right");
    }
}

module branch(direction="left", color1, color2, color3) {
    translate([distance/2,0])
    rotate([0,0,0])
        color(color1) segment();
    translate([distance,0, distance/2])
    rotate([0,90,0])
        color(color2) segment();
    d = direction == "left" ? distance/2 : -distance/2;
    translate([distance, d, distance])
    rotate([0,0,90])
        color(color3) segment();
}

module segment() {
    rcube([segmentLength, segmentWidth, segmentWidth], roundRadius);
}

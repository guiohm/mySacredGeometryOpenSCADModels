use <../lib/rounded_primitives.scad>;

$fn=33;

rotate([180,0,0])
difference() {
    rcylinder(r1=4, r2=4, h=28, b=2, center=false, fn=22);
    translate([0,0,7/2])
    cube([4, 4, 7], center=true);
}

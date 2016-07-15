a = 10.5;
b = 0.2; // base layer "squize" compensation
c = 0.3; // base layer height

cube(size=[a, a, a-0.3], center=false);
translate([b/2,b/2,-c])
cube(size=[a-b, a-b, c], center=false);

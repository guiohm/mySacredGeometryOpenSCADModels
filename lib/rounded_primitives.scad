// Rounded primitives for openscad
// (c) 2013 Wouter Robers

// Include line to copy/paste:
// include <../../lib/rounded_primitives.scad>;

// Syntax example for a rounded block
//translate([-15,0,10]) rcube([20,20,20],2);

// Syntax example for a rounded cylinder
//translate([15,0,10]) rcylinder(r1=15,r2=10,h=20,b=2);

use <maths.scad>;



module rcube(Size=[20,20,20],b=2) {
    hull() {
        for (x=[-(Size[0]/2-b),(Size[0]/2-b)]){
            for (y=[-(Size[1]/2-b),(Size[1]/2-b)]) {
                for (z=[-(Size[2]/2-b),(Size[2]/2-b)]) {
                    translate([x,y,z])
                    sphere(b);
                }
            }
        }
    }
}


module rcylinder(r1=10, r2=10, h=10, b=2, center=false, fn=20, oneSide=false) {
    t = center ? -h/2 : 0;
    facets = oneSide ? 4 : fn;
    translate([0,0,t])
    hull() {
        rotate_extrude()
            translate([r1-b,b,0])
                if (oneSide) {
                    square(2*b, center=true);
                } else {
                    circle(r=b, $fn=fn);
                }
        rotate_extrude()
            translate([r2-b, h-b, 0])
                circle(r=b, $fn=fn);
    }
}

module rEquilateralTriangle(side=10, height=10, b=2, center=true) {
    d = sideLengthFromPolygonInRadius(3, b);
    dd = polygonCircumRadius(3, d);
    inRadius = polygonInRadius(3, side);
    echo(d=d);
    echo(dd=dd);
    translate(center==true ? [-side/2,-inRadius,-height/2] : [0,0,0])
    linear_extrude(height=height)
        hull() {
            translate([d/2, b]) circle(b);
            translate([side-(d/2), b]) circle(b);
            translate([side/2, (sqrt(3)*side/2)-dd]) circle(b);
        }
}

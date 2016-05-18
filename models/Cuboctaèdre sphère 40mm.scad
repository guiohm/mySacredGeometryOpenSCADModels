version = 4;

arete = 20;
paroi = 1.35;
trou_bouchon = 0;
diametreTrouBouchon = 1.5;
bottomHole = 0;
bottomHoleDiameter = 1.2;
vertexHole = 0;
vertexHolesDiameter = 1;
sideHole = 0;
sideHolesDiameter = 1.2;

// distance entre la paroi extérieure et la découpe
// minimum semble etre >nozzle_diameter pour Zortrax M200
offset_decoupe_bouchon = 0.42;

echelleReductionAjustementBouchon = 0.98;
r = 0.19; // résolution d'impression sur l'axe Z

externalRadius = arete;
internalRadius = arete_from(int_radius(arete)-paroi);
echo(internalRadius=internalRadius);

use <../lib/Cuboctahedron.scad>;
use <../lib/Engineering_tools.scad>;

dihedralAngle = 125.264;

render(convexity=2)
//forme_creuse();
//decoupe_bouchon();
// corps_ouvert();
// bouchon();
//trou();
support();

module corps_ouvert() {
  // rotation pour face triangle
  // rotate([180 - dihedralAngle, 0, 0]) rotate([0, 0, 45])

  difference() {
    forme_creuse();
    decoupe_bouchon();
    if (bottomHole) {
      translate([0, 0, -externalRadius+1])
      #cylinder(paroi*3, r=bottomHoleDiameter/2, $fn=22);
    }
    if (sideHole) {
      rotate([0, 0, 45])
      rotate([180 - dihedralAngle, 0, 0])
      translate([0, 0, externalRadius*.6])
      #cylinder(paroi*3, r=bottomHoleDiameter/2, $fn=22);
    }
    if (vertexHole) {
      trou_pointe();
    }
  }
}

module bouchon() {
  // rotate([-90, 45, 0])
  scale([echelleReductionAjustementBouchon, echelleReductionAjustementBouchon, 0.99])
  difference () {
    intersection() {
        // forme_creuse();
        decoupe_bouchon(echelleReductionAjustementBouchon);
    }
    if (vertexHole) {
      trou_pointe();
    } else if (trou_bouchon) {
      trou();
    }
  }
}

module trou() {
    rotate([0, 0, 0])
    translate([0, 0, externalRadius*0.5])
    cylinder(30, r=diametreTrouBouchon/2, $fn=22);
}

module trou_pointe() {
    rotate([90, 0, 45])
    translate([0, 0, externalRadius*.7])
    #cylinder(paroi*3, r=bottomHoleDiameter/2, $fn=22);
}

module forme_creuse() {
  difference() {
    cuboctahedron(externalRadius);
    cuboctahedron(internalRadius);
  }
}

module decoupe_bouchon(scale=1) {
  distance = int_radius(arete)-paroi/2;
  d = arete-offset_decoupe_bouchon*2;
  rotate([0,0,45]) translate([0,0, distance])
    cube([d, d, paroi], center=true);
}

module support() {
  $fn=66;
  translate([0,0,arete+1-7/2])
  difference() {
    translate([0,0,-arete-1])
    cylinder(h=7, r=9);
    translate([0,0,-arete-2])
    cylinder(h=10, r=7);
    // tube(r=12, thickness=1, height=10, center=false, outline=false)
    rotate_on_vertex() #corps_ouvert();
  }
}

module rotate_on_vertex() {
    rotate([0, 45, 0]) rotate([0, 0, 0]) children();
}

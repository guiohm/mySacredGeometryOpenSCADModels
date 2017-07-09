// Cuboctaedre fil de fer 40mm

version = 5;

arete = 40;
paroi = 1.5;
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

echelleReductionAjustementBouchon = 0.99;
r = 0.19; // résolution d'impression sur l'axe Z

externalRadius = arete;
internalRadius = arete_from(int_radius(arete)-paroi);
echo(internalRadius=internalRadius);

eps=0.02;
// radius=20;
shell_ratio=0.1;
prism_base_ratio =0.83;
prism_height_ratio=0.3;
prism_scale=1.32;
nfaces = [];
scale=1;

include <Cuboctahedron.scad>;
use <../../lib/Engineering_tools.scad>;


// render(convexity=2)
// support();
// rotate_on_triangle() {
  cuboctahedron(arete, wireframe=true);
  VE_axis(arete, thickness=4);
// }

module support() {
  $fn=66;
  translate([0,0,arete+1-7/2])
  difference() {
    translate([0,0,-arete-1])
    cylinder(h=9, r=12);
    translate([0,0,-arete-2])
    cylinder(h=13, r=10.5);
    // tube(r=12, thickness=1, height=10, center=false, outline=false)
    // rotate_on_vertex() #corps_ouvert();
  }
}

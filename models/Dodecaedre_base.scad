// To use this file, copy && modify the header section
// then uncomment the needed parts.

////////////////////
//  HEADER START  //
////////////////////

// Uncomment only one of the 3 next variables.
// The 2 other will be automagically computed.
// _arete = 10;
// _diameter = 28.0252;
// _hauteurExt = 22.2703;

// You want to uncomment this...
// include <Dodecaedre_base.scad>;

epaisseurParoi = 1.5;
diametreTrouBouchon = 1.6;
bouchonOffset = 0.3;
r = 0.19; // résolution d'impression sur l'axe Z

// dode_creux();
// decoupe_bouchon();
// corps_ouvert();
// bouchon_avec_attache();
// bouchon();
// bouchon_trou();


////////////////////
//   HEADER END   //
////////////////////

function dode_inradius(arete) =
  arete*sqrt((5/2)+(11/10)*sqrt(5));

function dode_arete(height) =
  height/sqrt((5/2)+(11/10)*sqrt(5));

function dode_circumradius(arete) =
  arete*(1/4*(sqrt(3)+sqrt(15)));

function dode_arete_from_circumradius(radius) =
  radius/(1/4*(sqrt(3)+sqrt(15)));

function pentagon_circumradius(arete) =
  (arete/2)/cos(54);

// rayon cercle inscrit
function polygon_apothem(arete, sides) =
  arete/(2*tan(180/sides));

function polygon_apothem_from_circumradius(circumradius, sides) =
  circumradius*cos(180/sides);

function polygon_circumradius_from_apothem(apothem, sides) =
  apothem/cos(180/sides);


arete = _arete ? _arete :
  _diameter ? dode_arete_from_circumradius(_diameter/2) :
    dode_arete(_hauteurExt);

diameter = _diameter ? _diameter : 2*dode_circumradius(arete);

hauteurExt = dode_inradius(arete);
hauteurInt = hauteurExt - 2 * epaisseurParoi;
decoupe_bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 5) - 1*r,
              5);
bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 5) - 1*r - bouchonOffset,
              5);

echo(arete=arete);
echo(diameter=diameter);
echo(hauteurExt=hauteurExt);
echo(hauteurInt=hauteurInt);
echo(decoupe_bouchon_radius=decoupe_bouchon_radius);
echo(bouchon_radius=bouchon_radius);

module corps_ouvert() {
  difference() {
    dode_creux();
    #decoupe_bouchon(decoupe_bouchon_radius);
    #decoupe_feuillure(decoupe_bouchon_radius);
  }
}

module bouchon_avec_attache() {
  scale([1, 1, 0.995])
  union () {
    intersection() {
      dode_creux();
      decoupe_bouchon(bouchon_radius);
    }
    translate([0, 0, hauteurExt/2])
    rotate([90, 0, 54])
    rotate_extrude(convexity = 10, $fn=40)
    translate([1, 0, 0])
    circle(r = 0.5, $fn=40);
  }
}

module bouchon_trou() {
  scale([1, 1, 1])
  difference () {
    intersection() {
      dode_creux();
      decoupe_bouchon(bouchon_radius);
    }
    translate([0, 0, hauteurExt/2.5])
    cylinder(30, r=diametreTrouBouchon/2, $fn=22);
  }
}

module bouchon() {
  scale([1, 1, 1])
  difference () {
    intersection() {
      dode_creux();
      decoupe_bouchon(bouchon_radius);
    }
  }
}

module dode_creux() {
  difference() {
    dodecahedron(hauteurExt);
    dodecahedron(hauteurInt);
  }
}

module decoupe_bouchon(radius) {
  distance = hauteurInt/2+0*r;
  rotate([0,0,54]) translate([0,0,distance])
    cylinder(epaisseurParoi+0.01, r=radius, $fn=5);
}

module decoupe_feuillure(radius) {
  distance = hauteurInt/2+4*r;
  rotate([0,0,54]) translate([0,0,distance-epaisseurParoi])
    cylinder(epaisseurParoi, r=radius-epaisseurParoi, $fn=5);
}

module dodecahedron(height) {
  scale([height,height,height]) {
    intersection() {
      cube([2,2,1], center = true);
      intersection_for(i=[0:4]) {
        rotate([0,0,72*i])
        rotate([116.565,0,0])
          cube([2,2,1], center = true);
      }
    }
  }
}

// To use this file, copy && modify the header section
// then uncomment the needed parts.

////////////////////
//  HEADER START  //
////////////////////

// Uncomment only one of the 3 next variables.
// The 2 other will be automagically computed.
// _arete = 10;
// _circumradius = 28.0252;

// You want to uncomment this...
// include <Icosaedre_base.scad>;

r = 0.19; // résolution d'impression sur l'axe Z
epaisseurParoi = 1.5;
bottom_hole = 1; // on || off
bottom_hole_diameter = 1.6;

// distance entre la paroi extérieure et la découpe
// minimum. Printer specifics
offset_decoupe_bouchon = 0.3;
bouchonOffset = 0.3;
// TODO: bouchonThickness is not the real one: 0.8 gives full thickness
bouchonThickness = .6*epaisseurParoi;

// Permet meilleur encastrement du bouchon pour ne pas qu'il
// dépasse après collage
decoupeZOffset = -r;

// dode_creux();
// corps_ouvert();
// bouchon();


////////////////////
//   HEADER END   //
////////////////////

function ico_circumradius(arete) =
  arete*1/4*(sqrt(10+2*sqrt(5)));

function ico_inradius(arete) =
  arete/12*(3*sqrt(3)+sqrt(15));

function ico_arete_from(int_radius) =
  int_radius*12/(3*sqrt(3)+sqrt(15));

function ico_arete_from_circumradius(circumradius) =
  circumradius/(1/4*(sqrt(10+2*sqrt(5))));

function ico_rayon_circonscrit_face(arete) =
  arete*(sqrt(3)/3);

function ico_rayon_inscrit_face(arete) =
  arete*(sqrt(3)/6);

function ico_arete_from_rayon_circonscrit_face(r) =
  r/(sqrt(3)/3);

function ico_arete_from_rayon_inscrit_face(r) =
  r/(sqrt(3)/6);

// rayon cercle inscrit
function polygon_apothem(arete, sides) =
  arete/(2*tan(180/sides));

function polygon_apothem_from_circumradius(circumradius, sides) =
  circumradius*cos(180/sides);

function polygon_circumradius_from_apothem(apothem, sides) =
  apothem/cos(180/sides);

arete = _arete ? _arete :
      ico_arete_from_circumradius(_circumradius);

circumradius = _circumradius ? _circumradius : ico_circumradius(arete);

inRadius = ico_circumradius(
          ico_arete_from(
            ico_inradius(arete)-epaisseurParoi));

inHeight = ico_inradius(ico_arete_from_circumradius(inRadius));

decoupe_bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 3) - offset_decoupe_bouchon,
              3);
bouchon_radius = polygon_circumradius_from_apothem(
              polygon_apothem(arete, 3) - offset_decoupe_bouchon - bouchonOffset,
              3);

echo(arete=arete);
echo(circumradius=circumradius);
echo(inRadius=inRadius);
echo(inHeight=inHeight);
echo(decoupe_bouchon_radius=decoupe_bouchon_radius);
echo(bouchon_radius=bouchon_radius);


module corps_ouvert() {
//    rotate([0, 37.4, 0])
  difference() {
    union() {
      ico_creux();
      //#feuillure(decoupe_bouchon_radius);
    }
    decoupe_feuillure(decoupe_bouchon_radius);
    #decoupe_bouchon(decoupe_bouchon_radius, decoupeZOffset);
  }
}

module bouchon() {
//  rotate([180, 0, 0])
  scale([1, 1, 1])
  intersection() {
    ico_creux();
    decoupe_bouchon(bouchon_radius);
  }
}

module bouchon_trou(version) {
  scale([1, 1, 1])
  difference () {
    intersection() {
      ico_creux();
      decoupe_bouchon(bouchon_radius);
    }
    trou();
    // trou centre face
//    translate([0, 0, _circumradius*0.5])
//    cylinder(30, r=diametreTrouBouchon/2, $fn=22);
  }
}

module trou() {
  rotate([0, -37.3, 0])
    translate([0, 0, _circumradius*0.5])
    cylinder(30, r=diametreTrouBouchon/2, $fn=22);
}

module ico_creux() {
  difference() {
    icosahedron(circumradius);
    icosahedron(inRadius);
    if (bottom_hole) {
      translate([0, 0, -circumradius/2])
      cylinder(4*epaisseurParoi, d=bottom_hole_diameter, $fn=22, center=true);
    }
    if (side_hole) {
      rotate([dihedral_angle,0,0])
      translate([0, 0, -circumradius/2])
      cylinder(4*epaisseurParoi, d=side_hole_diameter, $fn=22, center=true);
    }
  }
}

module decoupe_bouchon(radius, zOffset = 0) {
  distance = inHeight+epaisseurParoi-bouchonThickness+zOffset;
  rotate([0,0,60]) translate([0,0,distance])
    cylinder(epaisseurParoi, r=radius, $fn=3);
}

module decoupe_feuillure(radius) {
  thickness = .666*epaisseurParoi;
  distance = inHeight-0.01;
  rotate([0,0,60]) translate([0,0,distance])
    cylinder(thickness, r1=ico_rayon_circonscrit_face(ico_arete_from_circumradius(inRadius)),      r2=radius-3*epaisseurParoi, $fn=3);
}

module feuillure(radius) {
  thickness = .666*epaisseurParoi;
  distance = inHeight;
  difference() {
    rotate([0,0,60]) translate([0,0,distance])
      cylinder(thickness,        r=radius+0.8*epaisseurParoi,        r2=radius+0.5*epaisseurParoi, $fn=3);
    rotate([0,0,60]) translate([0,0,distance])
      cylinder(thickness, r1=radius+0.1*epaisseurParoi,      r2=radius-1.8*epaisseurParoi, $fn=3);
  }
}

module support() {
  $fn=90;
  difference() {
    translate([0,0,-_circumradius*0.885])
    cylinder(_circumradius*0.27, r=_circumradius*0.4, center=true);
    translate([0,0,-_circumradius*0.9])
    cylinder(_circumradius, r=_circumradius*0.4-2, center=true);
    corps_ouvert();
  }
}


module icosahedron(rad=1) {
  Cphi = (1+sqrt(5))/2;

  // Convert spherical to cartesian
  function sph_to_cart(c, rad) = [
    rad*sin(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))*cos(atan2(c[1],c[0])),
    rad*sin(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))*sin(atan2(c[1],c[0])),
    rad*cos(atan2(sqrt(c[0]*c[0]+c[1]*c[1]), c[2]))
    ];


  //================================================
  //  Icosahedron
  //================================================
  //
  // (0, +-1, +-Cphi)
  // (+-Cphi, 0, +-1)
  // (+-1, +-Cphi, 0)

  function icosa_unit(rad) = [
    sph_to_cart([0, +1, +Cphi], rad),
    sph_to_cart([0, +1, -Cphi], rad),
    sph_to_cart([0, -1, -Cphi], rad),
    sph_to_cart([0, -1, +Cphi], rad),
    sph_to_cart([+Cphi, 0, +1], rad),
    sph_to_cart([+Cphi, 0, -1], rad),
    sph_to_cart([-Cphi, 0, -1], rad),
    sph_to_cart([-Cphi, 0, +1], rad),
    sph_to_cart([+1, +Cphi, 0], rad),
    sph_to_cart([+1, -Cphi, 0], rad),
    sph_to_cart([-1, -Cphi, 0], rad),
    sph_to_cart([-1, +Cphi, 0], rad),
    ];

  icosa_faces = [
    [3,0,4],
    [3,4,9],
    [3,9,10],
    [3,10,7],
    [3,7,0],
    [0,8,4],
    [0,7,11],
    [0,11,8],
    [4,8,5],
    [4,5,9],
    [7,10,6],
    [7,6,11],
    [9,5,2],
    [9,2,10],
    [2,6,10],
    [1,5,8],
    [1,8,11],
    [1,11,6],
    [5,1,2],
    [2,1,6]
    ];

  rotate([0, 20.905, 0]) polyhedron(icosa_unit(rad), faces = icosa_faces);
}

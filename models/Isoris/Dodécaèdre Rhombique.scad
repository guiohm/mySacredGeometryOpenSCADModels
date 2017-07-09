// Dodécaèdre Rhombique

sz=30;
sa=sz*1.5;

rotate([0,45])
dode_rhomb();

module dode_rhomb() {
    // take six rectangular solids and intersect them
    intersection() {
        rotate([45,0,0]) cube(size=[sa,sz,sz],center=true );
        rotate([-45,0,0]) cube(size=[sa,sz,sz],center=true );

        rotate([0,45,0]) cube(size=[sz,sa,sz],center=true );
        rotate([0,-45,0]) cube(size=[sz,sa,sz],center=true );

        rotate([0,0,45]) cube(size=[sz,sz,sa],center=true );
        rotate([0,0,-45]) cube(size=[sz,sz,sa],center=true );
    }
}

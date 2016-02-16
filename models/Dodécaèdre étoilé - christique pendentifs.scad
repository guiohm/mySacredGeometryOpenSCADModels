/*
code makes 5 objects

mark = 1 small stellated dodecahedron
         with a hole in one of the
         pentagonal pyramids

mark = 2  polyhedron with inverted
          pentagonal pyramids for faces
          the faces are equilateral triangles

mark = 3  polyhedron with outward facing
          pentagonal pyramids for faces
          the faces are equilateral triangles

mark = 4  an approximate pentakis dodecahedron
          catalan solid - faces isoceles triangles

mark = 5  simple dodecahedron

the single parameter passed to small_stellated_dodecahedron
is a scale factor   positive for pentagonal pyramids that
face out - negative for pentagonal pyramids that face in

pcm

*/





//  mark = 1;
//  mark = 2;
//  mark = 3;
//  mark = 4;
//  mark = 5;


    mark = 3;



if (mark==2)

union()
{
scale(18)
small_stellated_dodecahedron(-.8944);
hanger2(30);
}

else

if (mark==3)

union()
{
scale(18)
small_stellated_dodecahedron(0.8944);
hanger2(31);
}

else

if (mark==4)

union()
{
scale(18)
small_stellated_dodecahedron(0.4279);
hanger2(31);
}

else

if (mark==5)

union()
{
scale(18)
small_stellated_dodecahedron(0);
hanger2(31);
}

else

if (mark==1)

difference()
{
scale(13)
small_stellated_dodecahedron(2.3417);
decoration(0.72361,0,1.17082,1.5,20,18,23);
}



module small_stellated_dodecahedron(scale)
{
a=scale*0.61803;
b=scale*0.38197;



/*
constructed from 12 pentagonal pyramids placed
on the faces of a dodecahedron.
first 20 points are the vertices of a dodecahedron
next 12 points are the vertices of the centers
of the faces of the dodecahedron

if scale = 0 a dodecahedron is created

if scale is positive the centers of the
faces are moved out fron the center of the
dodecahedron

if scale is negative the centers of the
faces are moved in towards the center of the
dodecahedron

the apex angles of the triangles that make up
the faces of the stellated dodecahedron
are 36 degrees - the scale factor that
makes a small stellated dodecahedron
is approximately 2.3417
length of side of pentagonal pyramid for
small stellated dodecahedron = 2

the apex angles of the triangles that make up
the faces of a pentakis dodecahedron ( one of
the Catalan solids) are about 68.619 degrees
the scale factor to make one is ca 0.4279

if len = length of the sides of the
pentagonal pyramid then approximately

scale = + or - sqrt((len*len/0.52786) - 2.09443)

lengths of the sides of the base are sqrt(5)-1
or 1.23607 to make equilateral triangles scale
factor is 0.8944

distance from centers of faces to origin ca 1.37638
distance from dodecahedral points to origin sqrt(3)




pcm

*/

polyhedron
       (points = [
                 [   1.00000,   1.00000,   1.00000],
                 [   1.00000,   1.00000,  -1.00000],
                 [   1.00000,  -1.00000,   1.00000],
                 [   1.00000,  -1.00000,  -1.00000],
                 [  -1.00000,   1.00000,   1.00000],
                 [  -1.00000,   1.00000,  -1.00000],
                 [  -1.00000,  -1.00000,   1.00000],
                 [  -1.00000,  -1.00000,  -1.00000],
                 [   0.00000,   0.61803,   1.61803],
                 [   0.00000,   0.61803,  -1.61803],
                 [   0.00000,  -0.61803,   1.61803],
                 [   0.00000,  -0.61803,  -1.61803],
                 [   0.61803,   1.61803,   0.00000],
                 [   0.61803,  -1.61803,   0.00000],
                 [  -0.61803,   1.61803,   0.00000],
                 [  -0.61803,  -1.61803,   0.00000],
                 [   1.61803,   0.00000,   0.61803],
                 [   1.61803,   0.00000,  -0.61803],
                 [  -1.61803,   0.00000,   0.61803],
                 [  -1.61803,   0.00000,  -0.61803],
                 [   1.17082+a,   0.72361+b,   0.00000],
                 [   0.72361+b,   0.00000,   1.17082+a],
                 [   0.00000,   1.17082+a,   0.72361+b],
                 [   0.00000,   1.17082+a,  -0.72361-b],
                 [   0.72361+b,   0.00000,  -1.17082-a],
                 [   1.17082+a,  -0.72361-b,   0.00000],
                 [   0.00000,  -1.17082-a,   0.72361+b],
                 [   0.00000,  -1.17082-a,  -0.72361-b],
                 [  -0.72361-b,   0.00000,   1.17082+a],
                 [  -1.17082-a,   0.72361+b,   0.00000],
                 [  -0.72361-b,   0.00000,  -1.17082-a],
                 [  -1.17082-a,  -0.72361-b,   0.00000],
                   ],

           faces = [

                [0,20,16],[16,20,17],[17,20,1],
                [1,20,12],[12,20,0],
                [0,21,8],[8,21,10],[10,21,2],
                [2,21,16],[16,21,0],
                 [0,22,12],[12,22,14],[14,22,4],
                [4,22,8],[8,22,0],
                [1,23,9],[9,23,5],[5,23,14],
                [14,23,12],[12,23,1],
                [1,24,17],[17,24,3],[3,24,11],
                [11,24,9],[9,24,1],
                [16,25,2],[17,25,16],[3,25,17],
                 [13,25,3],[2,25,13],
                 [2,26,10],[10,26,6],[6,26,15],
                 [15,26,13],[13,26,2],
                 [3,27,13],[13,27,15],[15,27,7],
                 [7,27,11],[11,27,3],
                [4,28,18],[18,28,6],[6,28,10],
                 [10,28,8],[8,28,4],
                 [4,29,14],[14,29,5],[5,29,19],
                 [19,29,18],[18,29,4],
                  [5,30,9],[9,30,11],[11,30,7],
                 [7,30,19],[19,30,5],
                 [6,31,18],[18,31,19],[19,31,7],
                 [7,31,15],[15,31,6],

                 ]
      );
}


module hanger(tr)
{

 translate([-1.50,0,tr])
   rotate([0,90,0])
   linear_extrude(height=3)
   difference()    {
  circle(center=true,r=8,$fn=48);
  circle(center=true,r=6,$fn=48);
   }
 }

module hanger2(tr)
{

 translate([-1.50,0,tr])
   rotate([0,90,0])
   linear_extrude(height=3)
   difference()    {
  circle(center=true,r=7,$fn=48);
  circle(center=true,r=5,$fn=48);
   }
 }

module decoration(x2,y2,z2,rc,hc,rz,r2)
{
translate(v=[r2*x2,r2*y2,r2*z2])
rotate(a = [-acos(z2/sqrt(x2*x2+y2*y2+z2*z2)), 0, -atan2(x2, y2)])
rotate([0,90,rz])
   cylinder(r=rc,h=hc,center=true,$fn=24);
}


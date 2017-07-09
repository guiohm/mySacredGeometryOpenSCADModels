module beehome (w,l,h,s){
    difference (){
        cube([w,l,h]);
        #translate([(w%s)/2,(l%s)/2,0]){
            for ( j = [0 : s*1.96 : l] )    {
                for ( i = [0 : s*3.4 : w] ) {
                    translate([i,j,0])cylinder (h,s,s,$fn=6);
                    translate([i+s*1.7,j+s*0.96,0])cylinder (h,s,s,$fn=6);
                }
            }
        }
    }
}

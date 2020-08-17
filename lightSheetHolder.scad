// variables
mt = 3;
width = 270;
depth = 50;
sheetWidth = 200;
sheetThickness = 1.78;
ledWidth = 10;
ledLength = 200;
dimmerHoleWidth = 5;
dimmerWidth = 15;
dimmerDepth = 15;
screwDia = 3;

$fn = 60;

topPlate();
translate([0,depth+3,0])
    middlePlate();
translate([0,depth*2+6,0])
    bottomPlate();


module topPlate(){
    difference(){
        square([width,depth]);
        fillets();
        
        // sheet hole
        translate([width/2-sheetWidth/2,depth/2-sheetThickness/2]) 
            square([sheetWidth,sheetThickness]);
        
        // dimmer knob hole
        translate([(width-sheetWidth)/4,depth-dimmerDepth])
            circle(dimmerHoleWidth/2);
        
    }
}

function sideSpace() = (width-sheetWidth)/2;

module middlePlate(){
    difference(){
        square([width,depth]);
        fillets();
        screwHoles();

        // dimmer pcb hole
        translate([(width-sheetWidth)/4,depth-dimmerDepth]) square([dimmerWidth,dimmerDepth],center = true);
        // wire hole
        translate([0,depth-dimmerDepth]) square([(width-sheetWidth)/4,3]);
        translate([sideSpace()/2, depth/2]) square([sideSpace(),ledWidth/2]);

        translate([width/2-ledLength/2,depth/2-ledWidth/2]) 
            square([ledLength,ledWidth]);
        
    }
}

module bottomPlate(){
      difference(){
        square([width,depth]);

        fillets();
        screwHoles();

      }

}

module screwHoles(){
        // screw holse
        translate([screwDia*2,screwDia*2]) circle(screwDia/2);
        translate([width-screwDia*2,screwDia*2]) circle(screwDia/2);
        translate([width-screwDia*2,depth-screwDia*2]) circle(screwDia/2);
        translate([screwDia*2,depth-screwDia*2]) circle(screwDia/2);

}

module fillets(r = 5){
        // fillets
        fillet(r);
        translate([width,0]) rotate([0,0,90]) fillet(r);
        translate([width,depth]) rotate([0,0,180]) fillet(r);
        translate([0,depth]) rotate([0,0,-90]) fillet(r);

}

module fillet(r) {
    translate([r / 2, r / 2])

        difference() {
            square([r + 0.01, r + 0.01], center = true);

            translate([r/2, r/2, 0])
                circle(r =r);
        }
}


// variables
mt = 6;
width = 350;
depth = 60;

sheetWidth = 250;
sheetThickness = 8.15;
ledWidth = 10.5;
roomLength = 226;

dimmerHoleWidth = 6.5;
dimmerHoleOffset = [17,18.4];
dimmerWidth = 26;
dimmerDepth = 31;
screwDia = 3;

feetDia = 10;


$fn = 60;

spaceing(){
    topPlate();
    middlePlate();
    middlePlate();
    fillerPlate1();
    fillerPlate2();
    bottomPlate();
}

// Feets
translate([sideSpace() + 20, depth/2*3])
    for( i = [0:8]) translate([i*(feetDia+3)+5,0]) circle(feetDia/2);


module topPlate(){
    difference(){
        square([width,depth]);
        fillets();
        
        // sheet hole
        translate([width/2-sheetWidth/2,depth/2-sheetThickness/2]) 
            square([sheetWidth,sheetThickness]);
        
        // dimmer knob hole
        translate(dimmerPos()+dimmerHoleOffset)
            circle(dimmerHoleWidth/2);
        
    }
}

function sideSpace() = (width-sheetWidth)/2;
function dimmerPos() = [sideSpace()/2-dimmerWidth/2,depth/2-dimmerDepth/2];

module middlePlate(){
    difference(){
        square([width,depth]);
        fillets();
        screwHoles();
        dimmerPcb();

        // sheet hole
        translate([width/2-sheetWidth/2,depth/2-sheetThickness/2]) 
            square([sheetWidth,sheetThickness]);

        // Led room    
        translate([width/2-roomLength/2,(depth/2-ledWidth/2)/3]) 
            square([roomLength,1/3*(2*depth + ledWidth)]);
        
    }
}

module dimmerPcb(){
    // dimmer pcb hole
    translate(dimmerPos()) square([dimmerWidth,dimmerDepth]);
    // wire hole
    *translate([0,depth-dimmerDepth]) square([(width-sheetWidth)/4,3]);
    *translate([0,depth/2]) square([sideSpace(),ledWidth/2]);
}

module fillerPlate1(){
    difference(){
        square([width,depth]);
        fillets();
        screwHoles();
        dimmerPcb();

        airHoleDepth = (depth/2-ledWidth/2)*0.667;
        translate([sideSpace(),depth/2-ledWidth/2-airHoleDepth]) square([sheetWidth,airHoleDepth]);
        translate([sideSpace(),depth/2+ledWidth/2]) square([sheetWidth,airHoleDepth]);

    }
}

module fillerPlate2(){
    
    difference(){
        square([width,depth]);
        fillets();
        screwHoles();
        dimmerPcb();
        herringBones();


    }
}


module bottomPlate(){
      difference(){
        square([width,depth]);

        fillets();
        screwHoles();

        herringBones(depthAdjust = 5);

      }

}


module herringBones(wo=4,wi=9,count=17,depthAdjust=0){
        
        s = (wi-wo)/2;
        d = depth/2-ledWidth/2-depthAdjust;
        spaceing = (sheetWidth-wi)/count;   
        
        for(i = [0:count]){
            translate([sideSpace()+ i*spaceing ,depth/2+ledWidth/2]) 
                polygon([[0,0],
                         [wi,0],
                         [wi-s,d],
                         [s,d]]);

        }
        for(i = [0:count]){
            translate([sideSpace()+ i*spaceing ,depth/2-ledWidth/2]) 
                polygon([[0,0],
                         [wi,0],
                         [wi-s,-d],
                         [s,-d]]);

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

module spaceing(){
    for(i = [0:$children-1]) 
    translate([0,i*(depth+3)]) children(i);
}

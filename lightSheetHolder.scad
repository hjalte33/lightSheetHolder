// variables
mt = 6;
width = 330;
depth = 70;

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

twidth = 99;
tdepth = 46;
tswidth = 88.4;
tsdepth = 35.6;


$fn = 60;

color("dimgrey")
spaceing(stacked = false,thickness = mt){
    topPlate();
    holePlate();
    holePlate();
    ledPlate();
    decoratorPalte();
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
function dimmerPos() = [sideSpace()/2-dimmerWidth/2,depth/2-dimmerHoleOffset[1]];

module holePlate(){
    difference(){
        square([width,depth]);
        fillets();
        screwHoles();
        dimmerPcb(wires = true);

        // sheet hole
        translate([width/2-sheetWidth/2,depth/2-sheetThickness/2]) 
            square([sheetWidth,sheetThickness]);

        // Led room    
        translate([width/2-roomLength/2,(depth/2-ledWidth/2)/3]) 
            square([roomLength,1/3*(2*depth + ledWidth)]);
        
    }
}



module ledPlate(){
    difference(){
        square([width,depth]);
        fillets();
        screwHoles();
        dimmerPcb();


        herringBones();
        airHoleDepth = (depth/2-ledWidth/2)*0.667;
        *translate([sideSpace(),depth/2-ledWidth/2-airHoleDepth]) square([sheetWidth,airHoleDepth]);
        *translate([sideSpace(),depth/2+ledWidth/2]) square([sheetWidth,airHoleDepth]);

        }

        // screw pads for psu
    translate([sideSpace(),depth/2-tdepth/2]){
        translate([(twidth-tswidth)/2,(tdepth-tsdepth)/2]) circle(6);
        translate([(twidth-tswidth)/2+tswidth, (tdepth-tsdepth)/2+tsdepth]) circle(6);
    }
}

module decoratorPalte(){
    
    difference(){
        square([width,depth]);
        fillets();
        screwHoles();
        dimmerPcb();
        herringBones(depthAdjust = 8);
        psu();

    }
}


module bottomPlate(){
      difference(){
        square([width,depth]);

        fillets();
        screwHoles();
        psu();
        herringBones(depthAdjust = 8);

      }

}


module dimmerPcb(wires = false){
    // dimmer pcb hole
    translate(dimmerPos()){
        square([dimmerWidth,dimmerDepth]);
        
    }   
    if(wires){ 
        translate([sideSpace() - dimmerWidth ,depth/2-sheetThickness/2]) square([sideSpace(),sheetThickness]);
    } 
}


module psu(){
    wirehole = 15;
    translate([sideSpace(),depth/2-tdepth/2]){
        square([twidth,tdepth]);
        translate([twidth/2,tdepth/2]) square([twidth+28,wirehole],center=true);
        
    } 

}

module herringBones(wo=3,wi=6,count=26,depthAdjust=0){
        
        s = (wi-wo)/2;
        d = depth/2-ledWidth/2-depthAdjust;
        space = (sheetWidth-wi)/(count-1);   
        
        for(i = [0:count-1]){
            translate([sideSpace()+ i*space ,depth/2+ledWidth/2]) 
                polygon([[0,0],
                         [wi,0],
                         [wi-s,d],
                         [s,d]]);

        }
        for(i = [0:count-1]){
            translate([sideSpace()+ i*space ,depth/2-ledWidth/2]) 
                polygon([[0,0],
                         [wi,0],
                         [wi-s,-d-0.01], // rounding error bug thing... 
                         [s,-d-0.01]]);

        }
}

module screwHoles(){
        // screw holse
        translate([screwDia*2,screwDia*2]) circle(screwDia/2);
        translate([width-screwDia*2,screwDia*2]) circle(screwDia/2);
        translate([width-screwDia*2,depth-screwDia*2]) circle(screwDia/2);
        translate([screwDia*2,depth-screwDia*2]) circle(screwDia/2);

}

module fillets(r = 8){
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

module spaceing(stacked = false, thickness = 1){
    if(!stacked){
        for(i = [0:$children-1]) 
        translate([0,i*(depth+3)]) children(i);
    }
    else{
        for(i = [0:$children-1]){
            translate([0,0,i*thickness]) linear_extrude(thickness) children($children -1 - i); 
        }
    }

}

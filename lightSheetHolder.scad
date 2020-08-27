// variables
mt = 6;
width = 330;
depth = 70;

sheetWidth = 250;
sheetThickness = 8.1;
ledWidth = 10.5;
roomLength = 226;

dimmerHoleWidth = 7;
dimmerHoleOffset = [17,18.4];
dimmerWidth = 27;
dimmerDepth = 32;
screwHeadDia = 5;
screwDia = 3;
predrillDia = 1.8;


feetDia = 10;

psuWidth = 99;
psuDepth = 46;
psuScrewWidth = 88.4;
psuScrewDepth = 35.6;


$fn = 60;

color("dimgrey")
spaceing(stacked = true,thickness = mt){
    topPlate();
    holePlate();
    *holePlate(); // enable if you need more space four your electronics. 
    ledPlate();
    decoratorPalte();
    bottomPlate();
}

// Feets
translate([sideSpace() + 20, depth/2*3])
    for( i = [0:3]) translate([i*(feetDia+3)+5,0]) circle(feetDia/2);

translate([sideSpace() + 20, depth/2*3.5]){
    knob();
    translate([15,0,0]) knob();
    translate([30,0,0]) knob(hole = false);
}

module knob(hole = true){
    // knob
    r = 7;
    difference(){
        offset(r=1)
            difference(){
                circle(r);
                for (i=[0:10]){
                    rotate([0,0,i*360/8]) translate([r*1.25,0]) circle(r*0.6);
                }
            }
        // punch a center hole that fits the diameter of your potentiometer.
        if(hole) circle(5.8/2);
    }
}


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


module holePlate(){
    difference(){
        square([width,depth]);
        fillets();
        screwHoles(predrillDia/2);
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
        screwHoles(screwDia/2);
        dimmerPcb();


        herringBones();
        airHoleDepth = (depth/2-ledWidth/2)*0.667;
        *translate([sideSpace(),depth/2-ledWidth/2-airHoleDepth]) square([sheetWidth,airHoleDepth]);
        *translate([sideSpace(),depth/2+ledWidth/2]) square([sheetWidth,airHoleDepth]);

        }

        // screw pads for psu
    translate([sideSpace(),depth/2-psuDepth/2]){
        translate([(psuWidth-psuScrewWidth)/2,(psuDepth-psuScrewDepth)/2]) circle(6);
        translate([(psuWidth-psuScrewWidth)/2+psuScrewWidth, (psuDepth-psuScrewDepth)/2+psuScrewDepth]) circle(6);
    }
}

module decoratorPalte(){
    
    difference(){
        square([width,depth]);
        fillets();
        screwHoles(screwHeadDia/2);
        dimmerPcb();
        herringBones(depthAdjust = 8);
        psu();

    }
}


module bottomPlate(){
      difference(){
        square([width,depth]);

        fillets();
        screwHoles(screwHeadDia/2);
        psu();
        herringBones(depthAdjust = 8);

      }

}

function sideSpace() = (width-sheetWidth)/2;
function dimmerPos() = [sideSpace()/2-dimmerWidth/2,depth/2-dimmerHoleOffset[1]];

module dimmerPcb(wires = false){
    // dimmer pcb hole
    translate(dimmerPos()){
        square([dimmerWidth,dimmerDepth]);
        translate([0,-5])square([15,7]);
        translate([0,dimmerDepth])square([15,7]);

    }   
    if(wires){ 
        translate([sideSpace() - dimmerWidth ,depth/2-sheetThickness/2]) square([sideSpace(),sheetThickness]);
    } 
}


module psu(){
    wirehole = 15;
    translate([sideSpace(),depth/2-psuDepth/2]){
        square([psuWidth,psuDepth]);
        translate([psuWidth/2,psuDepth/2]) square([psuWidth+28,wirehole],center=true);
        
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

module screwHoles(r,pos=[12,7]){
        // screw holse
        translate(pos) circle(r);
        translate([width-pos[0],pos[1]]) circle(r);
        translate([width-pos[0],depth-pos[1]]) circle(r);
        translate([pos[0],depth-pos[1]]) circle(r);

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

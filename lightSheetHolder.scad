// variables
mt = 3;
width = 250;
depth = 50;
sheetWidth = 200;
sheetThickness = 1.78;
ledWidth = 10;
ledLength = 200;
dimmerHoleWidth = 5;
dimmerWidth = 15;
dimmerDepth = 15;

topplate();

module topPlate(){
    difference(){
        square([width,depth]);
        translate([width/2-sheetWidth/2,depth/2-sheetThickness/2]) 
            square([sheetWidth,sheetThickness]);
        translate([dimmerWidth,dimmerDepth])
            circle(dimmerHoleWidth/2);
    }
}

module bottomPlate(){
    
}
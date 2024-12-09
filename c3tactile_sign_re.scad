
// sign text can only be upper case letters or numbers
sign_text = "WC ALL GENDER";

//sign_font = "Cabin:style=Bold";
//sign_font = "Cantarell:style=Bold";
//sign_font = "Loma:style=Bold";
//sign_font = "Ubuntu:style=Bold";
sign_font = "Umpush:style=Bold";


dot_diam  = 2;
dot_space = 0.5;
braille_char_space = 2;

text_braille_vdist = 10;

// with these switches you can render background and text
// separately. This can be useful multi-color prints in
// bambulab studio (When importing the STLs into BLS select
// all STLs at once. Then BLS will ask you if these STLs make
// up a single object. Hit yes, and then you can assign different
// materials to the subobjekts...).
render_black = true;
render_white = true;
render_sunken_white = true; 
// ^^^ will only render something, if "enable_sunken_white" is true

// this switch will push the text and brailes "sunken_layers" into
// the background. This can be useful if you want to have a different
// color behind the text in the back plate. For example, printing
// a white color to increase the brightness of fluoresent filament
enable_sunken_white = false;
sunken_layers = 2;

layer_height = 0.2;

module braille_text(txt, layer_h, layer_cnt, extr_w = 0.4, c_sp = 2, dot_d = 2, dot_sp = 0.5)
{

    module braille_char(c) {

        base_height = layer_cnt > 1 ? layer_h * (layer_cnt-1) : layer_h * layer_cnt;

        module dot(){
            cylinder(d=dot_d,h=base_height,$fn=36);
            if (layer_cnt > 1)
            translate([0,0,base_height])
            cylinder(d=dot_d-extr_w*2,h=layer_h,$fn=36);
        }

        // stupid, but effective
        // bottom left    
        if (
            c == "K" || c == "L" || c == "M" || 
            c == "N" || c == "O" || c == "P" ||
            c == "Q" || c == "R" || c == "S" ||
            c == "T" || c == "U" || c == "V" ||
            c == "X" || c == "Y" || c == "Z" ||
            c == "Ä" || c == "ß" || c == "#"
        ) translate([dot_d/2,dot_d/2,0])
        dot();
        
        // bottom right
        if (
            c == "U" || c == "V" || c == "W" || 
            c == "X" || c == "Y" || c == "Z" ||
            c == "Ö" || c == "Ü" || c == "ß" ||
            c == "'" || c == "#"
        ) translate([dot_d/2+dot_d+dot_sp,dot_d/2,0])
        dot();

        // middle left
        if (
            c == "B" || c == "2" || c == "F" || 
            c == "6" || c == "G" || c == "7" ||
            c == "H" || c == "8" || c == "I" ||
            c == "9" || c == "J" || c == "0" ||
            c == "L" || c == "P" || c == "Q" ||
            c == "R" || c == "S" || c == "T" ||
            c == "V" || c == "W" || c == "Ö" ||
            c == "Ü" || c == "ß"
        ) translate([dot_d/2,dot_d/2+dot_d+dot_sp,0])
        dot();
        
        // middle right
        if (
            c == "D" || c == "4" || c == "E" || 
            c == "5" || c == "G" || c == "7" ||
            c == "H" || c == "8" || c == "J" ||
            c == "0" || c == "N" || c == "O" ||
            c == "Q" || c == "R" || c == "T" ||
            c == "W" || c == "Y" || c == "Z" ||
            c == "Ä" || c == "Ü" || c == "#"
        ) translate([dot_d/2+dot_d+dot_sp,dot_d/2+dot_d+dot_sp,0])
        dot();

        // top left
        if (
            c == "A" || c == "1" || c == "B" || 
            c == "2" || c == "C" || c == "3" ||
            c == "D" || c == "4" || c == "E" ||
            c == "5" || c == "F" || c == "6" ||
            c == "G" || c == "7" || c == "H" ||
            c == "8" || c == "K" || c == "L" ||
            c == "M" || c == "N" || c == "O" ||
            c == "P" || c == "Q" || c == "R" ||
            c == "U" || c == "V" || c == "X" ||
            c == "Y" || c == "Z" || c == "Ü"
        ) translate([dot_d/2,dot_d/2+(dot_d+dot_sp)*2,0])
        dot();
        
        // top right
        if (
            c == "C" || c == "3" || c == "D" || 
            c == "4" || c == "F" || c == "6" ||
            c == "G" || c == "7" || c == "I" ||
            c == "9" || c == "J" || c == "0" ||
            c == "M" || c == "N" || c == "P" || 
            c == "Q" || c == "S" || c == "T" || 
            c == "W" || c == "X" || c == "Y" || 
            c == "Ä" || c == "Ö" || c == "ß" || 
            c == "#"
        ) translate([dot_d/2+dot_d+dot_sp,dot_d/2+(dot_d+dot_sp)*2,0])
        dot();
        
    }

    module gen_char(cur_idx, numbers = false, shift = 0) {
        translate([shift,0,0])
        braille_char(txt[cur_idx]);
        if (cur_idx+1 < len(txt)) {
            if ((ord(txt[cur_idx+1]) >= ord("0")) && (ord(txt[cur_idx+1]) <= ord("9"))) {
                if (!numbers) {
                    translate([shift + dot_d*2+dot_sp+c_sp,0,0])
                    braille_char("#");
                    gen_char(cur_idx+1,true, shift + 2*(dot_d*2+dot_sp+c_sp));
                } else {
                    gen_char(cur_idx+1,true, shift + dot_d*2+dot_sp+c_sp);
                }                
            } else {
                if (numbers) {
                    translate([shift + dot_d*2+dot_sp+c_sp,0,0])
                    braille_char("'");
                    gen_char(cur_idx+1,false,shift + 2*(dot_d*2+dot_sp+c_sp));
                } else {
                    gen_char(cur_idx+1,false, shift + dot_d*2+dot_sp+c_sp);
                }
            }
        } 
    }
    
    // we need some recursion to handle numbers
    if ((ord(txt[0]) >= ord("0")) && (ord(txt[0]) <= ord("9"))) {
        braille_char("#");
        gen_char(0,true,dot_d*2+dot_sp+c_sp);
    } else {
        gen_char(0,false);
    }
          
}

function interpolate(from,to,weight) = from * (1 - weight) + to * weight;

module bevel_text(txt, size, layer_h, layer_cnt, no_bevel = false, fnt = "Cabin:style=Bold") {

    // base
    linear_extrude(height = no_bevel ? layer_h*layer_cnt : layer_h)
    text(text = txt, size = size, font = fnt, $fn=100);

    if ((layer_cnt > 1) && (!no_bevel))
    for(lc = [1:layer_cnt])
    translate([0,0,lc*layer_h])
    linear_extrude(height = layer_h)
    offset(r=interpolate(0,0.25,lc/layer_cnt),$fn=20)
    offset(r=interpolate(0,-0.7,lc/layer_cnt),$fn=20)
    text(text = txt, size = size, font = fnt, $fn=100);

}

braille_height = dot_diam*3+dot_space*2;

module txt_background(txt, size, h, edge_r,fnt = "Cabin:style=Bold") {

    linear_extrude(height = h)
    minkowski(){
        circle(r=edge_r,$fn=72);

        projection()
        intersection(){
            translate([0,-(braille_height+text_braille_vdist),0])
            rotate([-90,0,0])
            linear_extrude(height=size+10+braille_height+text_braille_vdist)
            hull()
            projection()
            rotate([90,0,0])
            linear_extrude(height = h)
            text(text = txt, size = size, font = fnt, $fn=100);

            union(){
                rotate([0,90,0])
                linear_extrude(height=(size+10)*len(txt))
                hull()
                projection()
                rotate([0,-90,0])
                linear_extrude(height = h)
                text(text = txt, size = size, font = fnt, $fn=100);
                
                translate([0,-(braille_height+text_braille_vdist),0])
                cube([(size+10)*len(txt),braille_height+text_braille_vdist,h]);
            }
        }                
    }

}

module txt_border(txt, size, h, edge_r, border_w, fnt = "Cabin:style=Bold") {

    linear_extrude(height = h)
    difference(){
        minkowski(){
            circle(r=edge_r,$fn=72);

            projection()
            intersection(){
                translate([0,-(braille_height+text_braille_vdist),0])
                rotate([-90,0,0])
                linear_extrude(height=size+10+braille_height+text_braille_vdist)
                hull()
                projection()
                rotate([90,0,0])
                linear_extrude(height = h)
                text(text = txt, size = size, font = fnt, $fn=100);

                union(){
                    rotate([0,90,0])
                    linear_extrude(height=(size+10)*len(txt))
                    hull()
                    projection()
                    rotate([0,-90,0])
                    linear_extrude(height = h)
                    text(text = txt, size = size, font = fnt, $fn=100);
                    
                    translate([0,-(braille_height+text_braille_vdist),0])
                    cube([(size+10)*len(txt),braille_height+text_braille_vdist,h]);
                }
            }                
        }

        offset(r=-border_w)
        minkowski(){
            circle(r=edge_r,$fn=72);

            projection()
            intersection(){
                translate([0,-(braille_height+text_braille_vdist),0])
                rotate([-90,0,0])
                linear_extrude(height=size+10+braille_height+text_braille_vdist)
                hull()
                projection()
                rotate([90,0,0])
                linear_extrude(height = h)
                text(text = txt, size = size, font = fnt, $fn=100);

                union(){
                    rotate([0,90,0])
                    linear_extrude(height=(size+10)*len(txt))
                    hull()
                    projection()
                    rotate([0,-90,0])
                    linear_extrude(height = h)
                    text(text = txt, size = size, font = fnt, $fn=100);
                    
                    translate([0,-(braille_height+text_braille_vdist),0])
                    cube([(size+10)*len(txt),braille_height+text_braille_vdist,h]);
                }
            }                
        }
    }
    
}

if(render_white)
color("white")
union(){
    bevel_text(sign_text,17,layer_height,6, fnt = sign_font);
    txt_border(sign_text,17,1,4,1, fnt = sign_font);
    translate([0,-braille_height-text_braille_vdist,0])
    braille_text(sign_text,layer_height,6,c_sp = braille_char_space, dot_d = dot_diam, dot_sp = dot_space);
}

if(render_black)
if(!enable_sunken_white) {
    color("black")
    translate([0,0,-1])
    txt_background(sign_text,17,1,5, fnt = sign_font);
} else {
    color("DarkSlateGray")
    difference(){
        translate([0,0,-1])    
        txt_background(sign_text,17,1,5, fnt = sign_font);
        
        translate([0,0,-sunken_layers*layer_height])
        bevel_text(sign_text,17,layer_height,6, no_bevel = true, fnt = sign_font);
        
        translate([0,0,-sunken_layers*layer_height])
        txt_border(sign_text,17,1,4,1, fnt = sign_font);

        translate([0,-braille_height-text_braille_vdist,-sunken_layers*layer_height])
        braille_text(sign_text,layer_height,6,c_sp = braille_char_space, dot_d = dot_diam, dot_sp = dot_space);
    }
}

if (enable_sunken_white && render_sunken_white) {
    color("white")
    translate([0,0,-sunken_layers*layer_height])
    bevel_text(sign_text,17,layer_height,sunken_layers, no_bevel = true, fnt = sign_font);

    color("white")
    translate([0,0,-sunken_layers*layer_height])
    txt_border(sign_text,17,sunken_layers*layer_height,4,1, fnt = sign_font);

    color("white")
    translate([0,-braille_height-text_braille_vdist,-sunken_layers*layer_height])
    braille_text(sign_text,layer_height,sunken_layers,extr_w = 0,c_sp = braille_char_space, dot_d = dot_diam, dot_sp = dot_space);

}




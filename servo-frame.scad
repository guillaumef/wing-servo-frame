/*
	Author: Guillaume F. ( g@w0.yt )
	License: GPL

	WING SERVO FRAME

 */


/* Configuration */

include <configuration.scad>

/*

  Servo sizes:

     H              E
   |---|         |----|
         _ _____000___          _
        /______000_ / |         _ F          _
       |           |  |         _            |
    /--|           | /---/      | G          |
   /---|           |/---/   -   -            |
     G |           |  |     |                | A 
       |           |  |     |D               |
       |           | /C     |                |
       |___________|/       _                _


       |-----------|
            B


  SERVO DIMENSIONS:

    Format: [ LEG_FORMAT, CABLE_SIDE, A, B, C, D, E, F, G, H ]
    
    - LEG_FORMAT: 0-no_ear, 1-horizontal_ears, 2-vertical_ears, 3-vertical_three_ears
    - A: body height (servo bottom to gear root)
    - B: body width (without ears)
    - C: body thickness
    - D: ear position (servo bottom to ear bottom)
    - E: gear center to body side (smallest one)
    - F: gear height
    - G: ear thickness (if vertical_ears, it is still the thickness of the ear) 
    - H: ear width (in no_ear mode, you can use it in // of the frame_extra_width)
    - I: ear height (only applicable to vertical_ears - 0 fallback to ear width)
    - J: if (vertical_ears_three_ears) - ear width bottom
         else                          - back notch height for external motor servo
    - K: ear hole size (Notch mode: negative value, Hole mode: positive value)
    - L: cable position (servo bottom to cable bottom)
    - M: gear screw diameter (required if 'with_bearing')
 

    Set servo_brand/servo_id the index of the servo needed.
 */


servos_kb	= [ 
/*       A     B     C     D     E     F     G     H     I     J     K     L     M */
/* Brand #0 - MKS */
[
/* Servo #0,0    - MKS DS6100 / HV6100                                           */
  [ 1,   20, 22.5,   10, 15.1, 4.75,  4.5,  1.2, 4.25,    0,    0,    2,    0,  2.5 ]
/* Servo #0,1    - MKS DS75K                                                     */
 ,[ 1, 16.7,   23,    9,  8.7,  4.8, 3.35,  1.2,    3,    0,    0,    2,    0,  2.5 ]
/* Servo #0,2    - MKS DS75K-N                                                   */
 ,[ 0, 16.7,   23,    9,   12,  4.8, 3.35,    0,    0,    0,    0,    0,    0,  2.5 ]
/* Servo #0,3    - MKS HV6130                                                    */
 ,[ 2, 29.5,   30,   10, 19.8,  6.5,  2.8,    2,    6,    8,    0,    3,    2,  2.5 ] 
]

/*       A     B     C     D     E     F     G     H     I     J     K     L     M */
/* Brand #1 - BlueBird */
,[
/* Servo #1,0   - BlueBird BMS-125WV / BMS-126WV / BMS-127WV                     */
  [ 1,   20, 23.2,   10,   15, 5.43,  3.8,  1.3,  4.6,    0,    0,   -2,    0,    3 ]
/* Servo #1,1   - BlueBird BMS-207WV                                             */
 ,[ 1, 27.5,   23,   12, 20.1,  5.7,  3.8,    2, 4.75,    0,    0,   -2,    6,    3 ]
/* Servo #1,2   - BlueBird BMS-115HV                                             */
 ,[ 2,   20, 23.2,   10, 12.5, 5.43,  3.8,  1.2,  4.6,    7,    0,   -2,    0,    3 ]
/* Servo #1,3   - BlueBird BMS-A10S                                              */
 ,[ 0,   21,   22,    8,   15,  5.1, 3.45,    0,    0,    0,    0,    0,    0,    2 ]
/* Servo #1,4   - BlueBird BMS-A10V                                              */
 ,[ 2,   21,   22,    8, 14.1,  5.1, 3.45,    1,    3,    5,    0,  1.8,    0,    2 ]
/* Servo #1,5   - BlueBird BMS-A10H                                              */
 ,[ 1,   21,   22,    8, 15.1,  5.1, 3.45,    1,    3,    0,    0,   -2,    0,    2 ]
]

/*       A     B     C     D     E     F     G     H     I     J     K     L     M */
/* Brand #2 - KST */
,[
/* Servo #2,0   - KST X12-508 HV                                                  */
  [ 1, 26.6,   23,   12, 19.9,  5.8,  3.5,  1.2,  4.5,    0,    0,   -2, 5.25,  2.5 ]
/* Servo #2,1   - KST X10 HV / DS125MG / DS225MG                                  */
 ,[ 3, 35.5,   30,   10, 27.5,  6.6,  3.3,  1.8,    6,    8, 10.1,    3, 14.5,  2.5 ]
/* Servo #2,2   - KST X10 MINI HV / DS135MG                                       */
 ,[ 3, 29.6,   30,   10, 21.6,  6.6,  3.3,  1.8,    6,    8, 10.1,    3, 10.5,  2.5 ]
/* Servo #2,3   - KST X10-710 HV / DS145MG                                        */
 ,[ 1, 29.6,   30,   10, 21.6,  6.6,  3.3,  1.9,    6,    0,    0,    3,    8,  2.5 ]
/* Servo #2,4   - KST X08 HV                                                      */
 ,[ 1,   21, 23.5,    8, 14.9, 6.13,  2.9,    1,    3,    0,    0,    2,    0,    2 ]
/* Servo #2,5   - KST X08H HV                                                     */
 ,[ 2,   21, 23.5,    8, 14.9,  6.1,  2.9,    1,    3,    4,    0,  1.6,    0,    2 ]
/* Servo #2,6   - KST X08N HV                                                     */
 ,[ 0,   21, 23.5,    8, 14.9, 6.13,  2.9,    0,    0,    0,    0,    0,    0,    2 ]
/* Servo #2,7   - KST X08 Plus HV                                                 */
 ,[ 1, 27.3, 23.5,    8,   21, 6.13,  2.9,    1,    3,    0,    0,    2,    0,    2 ]
/* Servo #2,8   - KST X08H Plus HV                                                */
 ,[ 2, 27.3, 23.5,    8,   21,  6.1,  2.9,    1,    3,    4,    0,  1.6,    0,    2 ]
/* Servo #2,9   - KST X06 HV                                                      */
 ,[ 1, 16.6,   20,    7, 11.9,   5,   2.7,    1,    4,    0,    0,    2,    0,    2 ]
/* Servo #2,10   - KST X06H HV                                                    */
 ,[ 2, 16.6,   20,    7,  8.9,   5,   2.7,    1,    3,    4,    0,  1.6,    0,    2 ]
/* Servo #2,11   - KST X06N HV                                                    */
 ,[ 0, 16.6,   20,    7, 11.9,   5,   2.7,    0,    0,    0,    0,    0,    0,    2 ]
/* Servo #2,12   - KST HS08B HV                                                    */
 ,[ 1, 25.3, 23.5,    8,   19,6.11,   3.2,    1,    3,    0,    0,    2,    0,    2 ]
/* Servo #2,13   - KST HS08A HV                                                    */
 ,[ 2, 25.3, 23.5,    8,   19,6.11,   3.2,    1,    3,    4,    0,  1.6,    0,    2 ]
/* Servo #2,14   - KST A08N                                                        */
 ,[ 0, 19.0, 23.5,    8, 12.9,5.85,   2.7,    0,    0,    0,    0,    0,    0,    2 ]
/* Servo #2,15   - KST A08                                                         */
 ,[ 1, 19.0, 23.5,    8, 12.9,5.85,   2.7,    1,    3,    0,    0,    2,    0,    2 ]
/* Servo #2,16   - KST A08H                                                        */
 ,[ 2, 19.0, 23.5,    8, 12.9,5.85,   2.7,    1,    3,    4,    0,    2,    0,    2 ]
]

/*       A     B     C     D     E     F     G     H     I     J     K     L     M */
/* Brand #3 - Emax : Double-check with digital caliper on those... */
,[
/* Servo #3,0   - Emax ES3352                                                     */
  [ 1,25.88,23.17, 9.30,17.25, 4.47,  3.4, 2.00, 4.60,    0,    0,  2.0,  2.6,    2 ]
/* Servo #3,1   - Emax ES08MDII                                                   */
 ,[ 1,   24,23.85, 11.8,   15, 5.42,  3.4, 1.65, 4.16,    0,    0,  2.0,    1,    2 ]
]

/*       A     B     C     D     E     F     G     H     I     J     K     L     M */
/* Brand #4 - TowerPro ... because sometimes you don't care */
,[
/* Servo #4,0   - TowerPro MG90D 15g                                              */
  [ 1, 28.5, 22.6,   12, 19.8, 6.00,    4, 2.25, 4.45,    0,    0,  1.6,    1,  2.5 ]
]

/*       A     B     C     D     E     F     G     H     I     J     K     L     M */
/* Brand #5 - KingMax */
,[
/* Servo #5,0   - KingMax CLS0911W                                                 */
  [ 3,  35.5,  30,   10, 27.25, 6.5,  3.2,  2.0,    6,    8, 10.0,    3, 14.0,  2.5 ]
/* Servo #5,1   - KingMax CLS0612W                                                 */
 ,[ 3,   30,   30,   10,    22, 6.5,  3.2,  2.0,    6,    8, 10.0,    3,  8.5,  2.5 ]
/* Servo #5,2   - KingMax C507                                                     */
 ,[ 2, 23.4, 23.5,    8,  15.1, 5.9,  2.7,  1.5,    3,  4.7,  3.3,  1.8,    0,    2 ]
]

/*       A     B     C     D     E     F     G     H     I     J     K     L     M */
/* Brand #6 - GDW */
,[
/* Servo #6,0   - GDW DS1906-A                                                     */
  [ 2,  23.5, 23.5,   8,  15.5, 5.4,  3.2,  1.1,    3,  3.8,  3.5,  1.5,    0,    2 ]
/* Servo #6,1   - GDW DS1906-B                                                     */
 ,[ 1,  23.5, 23.5,   8,  15.5, 5.4,  3.2,  1.1,    3,    0,    0,  1.5,    0,    2 ]
]

];


/* Bearing dimensions if needed.
 *
 *  [d, D, B]  =  [ internalDiameter, externalDiameter, thickness ]
 *
 * Set in servo_id the index of the servo needed.
 */

bearings_kb	= [

/*   #0    - MR52ZZ L-520ZZ          */
  [   2,   5, 2.5 ]
/*   #1    - 682XZZ                  */
 ,[ 2.5,   6, 2.6 ]
/*   #2    - MR63ZZ L-630ZZ          */
 ,[   3,   6, 2.5 ]
/*   #3    - MR83ZZ                  */
 ,[   3,   8,   3 ]
/*   #4    - MR93ZZ                  */
 ,[   3,   9,   4 ]
/*   #5    - MR84ZZ                  */
 ,[   4,   8,   3 ]
/*   #6    - MR85ZZ                  */
 ,[   5,   8, 2.5 ]
/*   #7    - MR95ZZ                  */
 ,[   5,   9,   3 ]

];

/*
 * Processing - internals and some spacers
 */

_servo_id_brand	= -1;
_servo_id_servo	= -1;
_bearing_id     = -1;
_proc		= -1;

servo	= (_servo_id_brand>=0 && _servo_id_servo>=0)
	?
	servos_kb[_servo_id_brand][_servo_id_servo]	/* From commandline */
	:
	servos_kb[ servo_id[0] ][ servo_id[1] ];

bearing	= (_bearing_id>=0)
	?
	bearings_kb[ _bearing_id ]
	:
	bearings_kb[ bearing_id ];

if (_proc == 1) {
	/* Ask for servo info -> bearing best match */
	for (x = [0:1:len(bearings_kb)-1]) {
		if (servo[ 13 ] == bearings_kb[x][0]) {
			_PRINT( "bearing:", x, " format:",bearings_kb[x][0],"x",bearings_kb[x][1],"x",bearings_kb[x][2] );
		}
	}
	_ERR("end");
}

if (! servo) {
	_ERR( "Missing servo definition !");
}

legformat		= servo[0];
s_h			= servo[1] 	+ .3;
s_w			= servo[2]	+ .3;
s_t			= servo[3];
s_h_ear			= servo[4]	+ .1;
s_w_gear		= servo[5];
s_gear_h		= servo[6];

s_ear_t			= (legformat)?servo[7]	+ .1 : 0;

s_ear_w			= (legformat)?servo[8]	+ .2 : 3;
s_ear_h			= (servo[9]?servo[9]:servo[8]) + .2;
s_ear_h_third		= (servo[10]?servo[10] + .2 : s_ear_h);

s_ear_isnotch		= (servo[11]<0) ? 1 : 0;
s_ear_hole_dia		= abs(servo[11]);
s_cable_h		= servo[12];
arm_screw_dia		= servo[13];

b_id			= bearing[0];
b_ed			= bearing[1];
b_t			= bearing[2] 	+ .4;

frame_gear_clearance	= frame_arm_clearance + arm_thickness;
frame_body_clearance	= frame_gear_clearance + s_gear_h;

if (arm_screw_dia > b_id) {
   _ERR( "BEARING INTERNAL DIAMETER inferior to SCREW DIAMETER" );
}

/* Checks */
_check_arm_diff	= (s_h_ear - s_h/2 - s_t) - (-s_h/2 + s_cable_h + 4);
_check_arm_fail = (legformat == 1 && ear_support_screw>0 && _check_arm_diff<0 && _check_arm_diff < s_ear_w/-2) ? 1 : 0;
if (_check_arm_fail) {
	_SEP();
	_WARN( "Unable to produce 'ear_support_screw'>0 - not enough space between cable and ear" );
	_WARN( "Falling back to ear_support_screw=0" );
	_SEP();
}
_ear_support_screw	= (_check_arm_fail || legformat==0)? 0 : ear_support_screw;


/* Modules.. */
module _SEP() { _PRINT("******************"); }
module _WARN( a="",b="",c="",d="",e="",f="",g="",h="",i="",j="" ) {
	echo(str("WARNING: ",a,b,c,d,e,f,g,h,i,j));
}
module _PRINT( a="",b="",c="",d="",e="",f="",g="",h="",i="",j="" ) {
	echo(str(a,b,c,d,e,f,g,h,i,j));
}
module _ERR( a="",b="",c="",d="",e="",f="",g="",h="",i="",j="" ) {
	if (version_num() > 20180101) {
		assert(false, str(a,b,c,d,e,f,g,h,i,j));
	}
	else {
		echo(str("ERROR: ",a,b,c,d,e,f,g,h,i,j));
	}
}

module servo_ear_solid( masky=0, issupport=0 ) {
	if (legformat <= 1) {
		/* ears */
		translate([ 0, s_h_ear - s_h/2 + s_ear_t/2, 0]) {
			cube([s_w+s_ear_w*2,s_ear_t, s_t+.1], center=true);
			if (issupport) {
				rotate([0,90,0]) {
					translate([0,s_ear_t/2,0])
					difference() {
						union(){
							cylinder(r=s_t/2,h=s_w+s_ear_w*2+frame_extra_width,center=true);
							translate([s_t/4,0,0])
								cube([s_t/2,s_t,s_w+s_ear_w*2+frame_extra_width],center=true);
						}
						translate([0,-s_t/2,0]) cube([s_t,s_t/2,s_w+s_ear_w*2],center=true);
					}
					if (legformat && _ear_support_screw) {
						translate([s_t/4,-s_t*3/4-s_ear_t/2+s_ear_w/2,0]) {
							cube([s_t/2,s_t/2+s_ear_w,s_w+s_ear_w*2+frame_extra_width],center=true);
						}
					}
					else {
						translate([0,-s_t/4-s_ear_t/2,0])
							cube([s_t,s_t/2,s_w+s_ear_w*2+frame_extra_width],center=true);
					}
				}
			}
			else {
				if (legformat && _ear_support_screw) {
					translate([0,-s_t/4-s_ear_t/2,0])
						cube([s_w+s_ear_w*2,s_t/2, s_t+.1], center=true);
					translate([0,-s_t*3/4-s_ear_t/2,0]) {
						translate([-s_w/2-s_ear_w/2,0,0])
							cylinder(r=0.8,h=200,center=true);
						translate([s_w/2+s_ear_w/2,0,0])
							cylinder(r=0.8,h=200,center=true);
					}

					if (_ear_support_screw > 1) { /* with servo ear screw */ 
						translate([-s_w/2-s_ear_w/2,s_ear_t/2,0])
							cylinder(r=ear_support_screwhead/2,h=s_t*2,center=true);
						translate([s_w/2+s_ear_w/2,s_ear_t/2,0])
							cylinder(r=ear_support_screwhead/2,h=s_t*2,center=true);
					}
				}
			}
		}
	}
	/* All except 3 vertical_ears */
	if (issupport && legformat<=2) {
		/* bottom blocker */
		translate([0,-s_h/2,-s_t/2])
		{
			wall=(s_ear_w<4)?2:s_ear_w/2;
			difference()
			{
				rotate([0,90,0])
					scale([s_t,s_ear_w+frame_extra_width,1])
					difference() {
						cylinder(r=1,h=s_w,center=true);
						if (frame_mode_light)
							cylinder(r=.7,h=s_w,center=true);
					}
				translate([0,0,-500])
					cube([1000,1000,1000],center=true);
				translate([0,500,0])
					cube([1000,1000,1000],center=true);
				nb=3;
				cell=(s_w-wall*(nb+1))/nb;
				for(x=[-s_w/2+wall:cell+wall:s_w/2]) {
					translate([x+cell/2,-s_h/2-wall,0])
						cube([cell,s_h,1000],center=true);
				}
			}
			if (frame_mode_light) {
				translate([0,-wall/2,s_t/2])
					cube([s_w,wall,s_t*.8],center=true);
			}
			/* no z-axis locking - adding a flat surface */
			if (_ear_support_screw == 0) {
				translate([0,-s_ear_w/2,s_t/2])
					cube([s_ear_w*2,s_ear_w+frame_extra_width,s_t],center=true);
			}
		}
	}
	/* All vertical_ears */
	if (legformat > 1) {
		surround_spacer = 2;
		translate([ 0, s_h_ear - s_h/2 + s_ear_h/2, masky/2])
			rotate([90,0,0])
			cube([s_w+s_ear_w*2,s_ear_t+masky, s_ear_h], center=true);
		if (issupport) {
			translate([ 0, s_h_ear - s_h/2 + s_ear_h/2, (s_ear_t-s_t)/4])
				rotate([90,0,0])
				cube([s_w+s_ear_w*2+surround_spacer,
						(s_t+s_ear_t)/2,
						s_ear_h+surround_spacer], center=true);
		}
		if (legformat==3) {
			translate([0, -s_h/2 - s_ear_w/2, masky/2])
				rotate([90,0,90])
				cube([s_ear_w*2,s_ear_t+masky, s_ear_h_third], center=true);
			if (issupport) {
				translate([0, -s_h/2 - s_ear_w/2, (s_ear_t-s_t)/4])
					rotate([90,0,90])
					cube([s_ear_w+surround_spacer,
							(s_t+s_ear_t)/2,
							s_ear_h_third+surround_spacer], center=true);
			}
		}
	}
}


module servo_cover_hole_mask() {
	if (_ear_support_screw == 0 && z_axis_servo_cover) {
		translate([(s_w+s_ear_w+frame_extra_width/2)/2, s_ear_w,0])
			cylinder(r=.8,h=100,center=true);
		translate([-(s_w+s_ear_w+frame_extra_width/2)/2, s_ear_w,0])
			cylinder(r=.8,h=100,center=true);
		translate([0,-(s_h+s_ear_w+frame_extra_width/2)/2,0])
			cylinder(r=.8,h=100,center=true);
	}
}

module servo_cover() {
	if (_ear_support_screw == 0 && z_axis_servo_cover) {
		translate([0,-s_h/2-frame_extra_width-s_ear_w*3-10,-s_t/2])
		difference() {
			translate([0,s_ear_w*2,0])
			{
				xmax = (s_w+frame_extra_width)/2+s_ear_w;
				ymax = (s_h+frame_extra_width)/2+s_ear_w+s_ear_w*2;
				linear_extrude(1)
					polygon([
							[-xmax,-s_ear_w*2], [-xmax,0],
							[xmax,0], [xmax,-s_ear_w*2],
							[s_ear_w,-ymax],
							[-s_ear_w,-ymax]
					]);

			}
			servo_cover_hole_mask();
		}
	}
}

module servo_ear_support_screw_solid() {
	if (legformat == 1 && _ear_support_screw) {
		translate([ -s_h, -s_t-s_h/2-s_ear_w-frame_extra_width - 10, -s_t/2]) {
			difference() {
				linear_extrude(s_ear_w) polygon([
						[0,0],[0,s_t*.4],
						[s_t/2,s_t/2], [s_t/2,s_t],
						[s_t - 2,s_t], [s_t - 2,s_t/2],
						[s_t, s_t/2], [s_t, 0]
				]);
				translate([s_t/2,s_t*3/4,s_ear_w/2])
					rotate([0,90,0])
					cylinder(r=0.8,h=s_t,center=true);

				/* if cable is too high ... cut the L-shaped part like
				 * the frame cube with the matching hole was cut */
				diff = (s_h_ear - s_h/2 - s_t) - (-s_h/2 + s_cable_h + 4);
				if (diff < 0) {
					translate([s_t/2, s_t + diff + 2,0])
						cube([6,4,1000],center=true);
				}
			}
			if (_ear_support_screw != 2) {
				dia = s_ear_hole_dia - .4; /* with minkowski sphere */
				/* ear hole */
				difference() {
					minkowski()
					{
						translate([s_t/2,0,s_ear_w/2]) {
							rotate([90,0,0]) {
								difference(){
									cylinder(r=dia/2,h=(s_ear_t-.2)*2,center=true);
									if (! s_ear_isnotch) {
										rotate([55,0,0])
											translate([0,0,500+(s_ear_t+dia)/4])
											cube([1000,1000,1000],center=true);
									}
								}
							}
							if (s_ear_isnotch) {
								/* With central notch */
								translate([0,0,-s_ear_w/4])
									cube([dia,(s_ear_t-.2)*2,s_ear_w/2],center=true);
							}
						}
						sphere(0.2, $fn=20);
					}
					translate([0,0,-500])
						cube([1000,1000,1000],center=true);
				}
			}
		}
	}
}
module servo_ear_support_screw() {
	servo_ear_support_screw_solid();
	mirror([1,0,0])
		servo_ear_support_screw_solid();
}

module servo_bearing_holder( issupport=0, locker=0 ) {
	locker_h   = (s_t - b_ed)/2 + b_ed/8;	/* locker lands at 1/8th of the bearing */
	if (issupport == 0) {
		if (locker == 0) {
			/* Bearing surround */
			translate([s_w/2-s_w_gear,s_h/2+(b_t*2)/2+frame_body_clearance+frame_extra_width/2,0]) {
				rotate([90,0,0]) {
					cylinder(r=(b_ed-1)/2, h=b_t*2+frame_extra_width+0.1, center=true);
					translate([0,s_t/4,0]) cube([b_ed-1,s_t/2,b_t*2+frame_extra_width+0.1],center=true);
				}
			}
			/* Bearing screw head opening */
			if (arm_screw_dia == b_id) {
				translate([s_w/2-s_w_gear,s_h/2+frame_body_clearance+b_t,0]) {
					rotate([90,0,0]) {
						translate([0,0,-b_t]) {
							cylinder(r=arm_screw_head_dia/2+.5, h=b_t, center=true);
						}
					}
				}
			}
			/* Bearing */
			translate([s_w/2-s_w_gear,s_h/2+frame_body_clearance,0]) {
				rotate([90,0,0]) {
					translate([0,0,-b_t]) {
						/* Ovalized a bit to avoid any unecessary vertical force on the shaft */
						scale([1,1.2,1])
							cylinder(r=b_ed/2, h=b_t, center=true);
						translate([0,s_t/4,0]) cube([b_ed,s_t/2,b_t],center=true);
					}
				}
			}
		}
		/* Bearing locker */
		translate([s_w/2-s_w_gear,s_h/2+frame_body_clearance,0]) {
			rotate([90,0,0]) {
				b_t_clearance = ((locker) ? 0.2:0);
				translate([0,0,-b_t + b_t_clearance/2]) {
					difference() {
						translate([0,s_t/2 - 1.5,0]) cube([s_w,3,b_t-b_t_clearance],center=true);
						scale([1,1.2,1]) /* also ovalized */
							cylinder(r=b_ed/2, h=b_t+1, center=true);
					}
				}
			}
		}
	}
	if (issupport) {
		translate([s_w/2-s_w_gear,s_h/2+frame_body_clearance+b_t,-s_t/2]) {
			rotate([90,0,0]) {
				scale([ s_w_gear+s_ear_w+frame_extra_width,s_t,1])
					difference() {
						cylinder( r=1, h=b_t*2, center=true );
						translate([0,-500,0]) cube([1000,1000,1000],center=true);
					}
			}
		}
	}
}

module servo_bearing_holder_cut_mask() {
	translate([0,s_h/2+(b_t*2)/2+frame_body_clearance,0]) {
		translate([0,0,s_t - 1.2])
			cube([b_t,b_t*1.5,s_t],center=true);
		translate([s_w-s_w_gear*2,0,s_t - 1.2])
			cube([b_t,b_t*1.5,s_t],center=true);
	}
}
module servo_bearing_holder_screw_mask() {
	translate([0,s_h/2+(b_t*2)/2+frame_body_clearance,0]) {
		cylinder(r=.8,h=s_t*2, center=true, $fn=20);
		translate([s_w-s_w_gear*2,0,0])
			cylinder(r=.8,h=s_t*2, center=true, $fn=20);
	}
}

module servo_bearing_holder_wscrew( issupport=0, locker=0 ) {
	difference() {
		servo_bearing_holder( issupport, locker );
		servo_bearing_holder_cut_mask();
		servo_bearing_holder_screw_mask();
	}
}

module servo_gear_solid( issupport=0 ) {
	translate([s_w/2-s_w_gear,s_h/2+s_gear_h/2,0]) {
		rotate([90,0,0])
		cylinder(r=2.75, h=s_gear_h, center=true, $fn=20);
	}
	if (with_bearing) {
		if (with_bearing != 2) {
			servo_bearing_holder_wscrew( issupport );
		}
		if (with_bearing != 1) {
			mirror([1,0,0])
				servo_bearing_holder_wscrew( issupport );
		}
	}
}

module servo_bearing_holder_fullscrew_mask() {
	if (with_bearing) {
		if (with_bearing != 2) {
			servo_bearing_holder_screw_mask();
		}
		if (with_bearing != 1) {
			mirror([1,0,0])
				servo_bearing_holder_screw_mask();
		}
	}
}

module servo_cable_solid(y=0) {
	w = (legformat<2) ? 4 : 6;
	t = (legformat<2) ? 6 : 4;
	translate([0,-s_h/2+w/2 + s_cable_h,y/2]) {
		cube([s_w + (s_ear_w + frame_extra_width) * 2,w,t+y], center=true);
	}
}

/* Servo mask */
module servo_solid() {
	union() {
		/* Z: +2 for preview */
		cube([s_w, s_h, s_t+2], center=true);

		servo_ear_solid();

		servo_gear_solid();

		servo_cable_solid();
	}
}

module servo_solid_mask() {
	union() {
		servo_solid();

		servo_cable_solid(100);

		if (legformat>1) {
			servo_ear_solid(100);
		}

		/* Servo gear clearance */
		translate([0, frame_body_clearance/2,0])
			/* Z: +2 for preview */
			cube([s_w, s_h+frame_body_clearance, s_t+2], center=true);

		servo_bearing_holder_fullscrew_mask();
	}
}

/* Frame */

module frame_solid_light_mask() {
	sz=(s_ear_w + frame_extra_width) / 3.0;
	bdx=(s_w+s_ear_w+frame_extra_width)/2;
	bdy=(s_h+s_ear_w+frame_extra_width)/2;
	bdymax = bdy + frame_body_clearance;
	ratiodensity = floor(bdx/sz);
	for(x=[bdx*-1:(bdx*2)/ratiodensity:bdx+0.01]) {
		for(y=[bdy*-1:(bdy+bdymax)/ratiodensity:bdymax+0.01]) {
			translate([x,y,0])
				cube([ sz, sz, 1000 ], center=true);
		}
	}
}

module frame_solid() {
	extra_width = frame_extra_width - minkowski_rounded;

	difference() {
		arm_clearance = frame_body_clearance;
		union() {
			translate([     0,
					arm_clearance/2,
					-50 + frame_thickness - minkowski_rounded]) {
				minkowski() {
					cube([
							s_w + (s_ear_w + extra_width) * 2,
							s_h + (s_ear_w + extra_width)*2 + arm_clearance,
							frame_thickness + 100 ],
							center=true);
					sphere( minkowski_rounded );
				}
			}

			if (with_boxed) {
				translate([     0,
						arm_clearance/2,
						boxed_h/2]) {
					difference() {
						minkowski() {
							cube([
									boxed_w - minkowski_rounded,
									boxed_l - minkowski_rounded,
									boxed_h +100 ],
									center=true);
							sphere( minkowski_rounded );
						}
						translate([0,0,100-boxed_h/2 + frame_thickness]) {
							minkowski() {
								cube([
										boxed_w - minkowski_rounded - boxed_thickness*2,
										boxed_l - minkowski_rounded - boxed_thickness*2,
										200 - minkowski_rounded ],
										center=true);
								sphere( minkowski_rounded );
							}
						}
						if (boxed_light) {
							yhalf=(boxed_w-boxed_thickness*2-minkowski_rounded*2)/2;
							for (y=[-yhalf:boxed_light*3:+yhalf])
							translate([0,y,-(s_t)/2+frame_thickness])
								cube([1000,boxed_light,s_t],center=true);
							xhalf=(boxed_l-boxed_thickness*2-minkowski_rounded*2)/2;
							for (x=[-xhalf:boxed_light*3:+xhalf])
							translate([x,0,-(s_t)/2+frame_thickness])
								cube([boxed_light,1000,s_t],center=true);
						}
						translate([-500,-500,boxed_h/2])
							cube([1000,1000,1000]);
					}
				}
			}
		}
		translate([-500,-500,-1000])
			cube([1000,1000,1000]);
		if (frame_mode_light)
			frame_solid_light_mask();
	}
}

module frame_w_ear_solid() {
	union() {
		translate([0,0, -s_t/2]) /* regulate y to servo side */
			frame_solid();
		servo_ear_solid(0,1);
		servo_gear_solid(1);
	}
}

module bearing_shaft_solid() {
	if (with_bearing) {

		cyl_visible = frame_arm_clearance + b_t/2;
		cyl_visible_dia = b_id + 1;

		cyl_bearing = ((arm_screw_head_dia == b_id || arm_screw_dia == b_id) ?
				0 /* The screw head or the screw is holding the bearing */
				:
				b_t+1 /* The shaft is entering the bearing */
				);
		screw_bearing = (arm_screw_dia == b_id) ? b_t : 0;
		cyl_bearing_dia = b_id - 0.1;

		translate([-s_w/2, s_t+s_h/2+frame_body_clearance+frame_extra_width + 10, -s_t/2])
		difference() {
			union() {
				translate([ 0,0, cyl_visible/2 ])
					cylinder( r1 = arm_screw_dia,	/* double the screw dia */
							r2 = cyl_visible_dia / 2,
							h = cyl_visible, center=true );

				if (cyl_bearing) {
					translate([ 0,0, cyl_visible + cyl_bearing/4 ]) {
						cylinder( r = cyl_bearing_dia / 2,
								h = cyl_bearing/2, center=true );
						translate([ 0,0, cyl_bearing/2 ])
							cylinder( r1 = cyl_bearing_dia / 2,
									r2 = (cyl_bearing_dia-.4) / 2,
									h = cyl_bearing/2, center=true );
					}
				}
			}
			cylinder( r = arm_screw_dia/2+0.1, h = 1000, center=true );
		}

		_SEP();
		_PRINT("Bearing shaft/arm screw:");
		if (cyl_bearing) {
			_PRINT("**** the shaft inserted in the bearing is printed");
		}
		else if (arm_screw_head_dia == b_id) {
			_PRINT("**** 'arm_screw_head_dia' matches bearing internal diameter:");
			_PRINT("**** >> the screw head is the bearing shaft");
		}
		else {
			_PRINT("**** 'arm_screw_dia' matches bearing internal diameter:");
			_PRINT("**** >> the screw is the bearing shaft");
		}
		_PRINT("**** screw length (threaded part) should be approximately between ",
				arm_thickness + cyl_visible + cyl_bearing + screw_bearing + 2,
				" and ",
				arm_thickness + cyl_visible + cyl_bearing + screw_bearing + s_gear_h+1, " mm");
		_PRINT("**** >> Tuning the length is possible with the 'frame_arm_clearance' parameter");
		_PRINT("**** screw thread metric is M", arm_screw_dia);
		if (! cyl_bearing && ! screw_bearing) {
			_PRINT("**** screw head is a cylinder with a ", arm_screw_head_dia, "mm diameter");
		}
		_SEP();
	}
}

module bearing_lock_solid() {
	if (with_bearing) {
		translate([s_w/2, s_t+s_h/2+frame_body_clearance+frame_extra_width+10, -s_t/2])
			rotate([90,0,0])
			translate([-frame_body_clearance,-b_t/2-frame_body_clearance-s_h/2,-s_t/2])
			intersection() {
				servo_bearing_holder_wscrew(1);
				servo_bearing_holder(0,1);
			}
	}
}

module servo_back_support_special() {
	if (legformat<3 && s_ear_h_third) {
		/* Special added notch to block servo with external motor */
		notch_w = s_w - s_t*2 - 5;
		if (notch_w>1) {
			translate([0,s_ear_h_third/2 -s_h/2,0])
				cube([ notch_w, s_ear_h_third, s_t ],center=true);
		}
	}
}

module servo_frame() {
	difference() {
		frame_w_ear_solid();
		servo_solid_mask();
		servo_cover_hole_mask();
	}
	servo_back_support_special();
}

module servo_frame_parts() {
	servo_frame();
	servo_ear_support_screw();
	servo_cover();
	bearing_shaft_solid();
	bearing_lock_solid();
}

servo_frame_parts();


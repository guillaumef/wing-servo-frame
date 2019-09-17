/*
	Author: Guillaume F. ( g@w0.yt )
	License: GPL

  Changelog:
   2019-09-14: bearing locker, manage notch/hole servo ear, code cleanup.
   2019-09-11: manage higher cable position like the KST X12.
   2019-09-11: manage dual bearing frame, enhance the tolerance, ear screw mount refactored.


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
    - J: ear width bottom (only applicable to vertical_ears_three_ears - 0 fallback to 'I')
    - K: ear hole size (Notch mode: negative value, Hole mode: positive value)
    - L: cable position (servo bottom to cable bottom)
    - M: gear screw diameter (required is 'with_bearing')
 

    Set servo_brand/servo_id the index of the servo needed.
 */

servo_id	= [ 1 , 0 ];   /* Brand,Servo */

servos_kb	= [ 
/*
 *        A     B     C     D     E     F     G     H     I     J     K     L     M
 */
/* Brand #0 - MKS */
[
/* Servo #0,0    - MKS DS6100 / HV6100                                           */
  [ 1,   20, 22.5,   10, 15.1, 4.75,  4.5,  1.2, 4.25,    0,    0,    2,    0,  2.5 ]
/* Servo #0,1    - MKS DS75K                                                     */
 ,[ 1, 16.7,   23,    9,  8.7,  4.8, 3.35,  1.2,    3,    0,    0,    2,    0,  2.5 ]
/* Servo #0,2    - MKS DS75K-N                                                   */
 ,[ 0, 16.7,   23,    9,    9,  4.8, 3.35,    0,    0,    0,    0,    0,    0,  2.5 ]
/* Servo #0,3    - MKS HV6130                                                    */
 ,[ 2, 29.5,   30,   10, 19.8,  6.5,  2.8,    2,    6,    8,    0,    3,    2,  2.5 ] 
]

/* Brand #1 - BlueBird */
,[
/* Servo #1,0   - BlueBird BMS-125WV / BMS-126WV / BMS-127WV                     */
  [ 1,   20, 23.3,   10,   15, 5.43,  3.8,  1.3,  4.6,    0,    0,   -2,    0,    3 ]
/* Servo #1,1   - BlueBird BMS-207WV                                             */
 ,[ 1, 27.5,   23,   12, 20.1,  5.7,  3.8,    2, 4.75,    0,    0,   -2,    6,    3 ]
]

/* Brand #2 - KST */
,[
/* Servo #2,0   - KST X12-508 HV        (screw M2.3, why so evil?  => M2.5 tap ) */
  [ 1, 26.6,   23,   12, 19.9,  5.8,  3.5,  1.2,  4.5,    0,    0,   -2, 5.25,  2.5 ]
/* Servo #2,1   - KST X10 HV | KST X10 MINI HV                                    */
 ,[ 3, 29.6,   30,   10, 21.6,  6.6,  3.3,  1.8,    6,    8, 10.1,    3, 14.5,  2.5 ]
/* Servo #2,2   - KST X10-710 HV                                                  */
 ,[ 1, 29.6,   30,   10, 21.6,  6.6,  3.3,  1.9,    6,    0,    0,    3,    8,  2.5 ]
/* Servo #2,3   - KST X08H V5 HV                                                  */
 ,[ 2,   21, 23.5,    8, 14.9,  6.1,  2.9,    1,    3,    4,    0,  1.6,    0,    2 ]
/* Servo #2,4   - KST X08 V5 HV                                                   */
 ,[ 1,   21, 23.5,    8, 14.9, 6.13,  2.9,    1,    3,    0,    0,    2,    0,    2 ]
]

/* Brand #3 - Emax : Double-check with digital caliper on those... */
,[
/* Servo #3,0   - Emax ES3352                                                     */
  [ 1,25.88,23.17, 9.30,17.25, 4.47,  3.4, 2.00, 4.60,    0,    0,  2.0,  2.6,    2 ]
/* Servo #3,1   - Emax ES08MDII                                                   */
 ,[ 1,   24,23.85, 11.8,   15, 5.42,  3.4, 1.65, 4.16,    0,    0,  2.0,    1,    2 ]
]

/* Brand #4 - TowerPro ... because sometimes you don't care */
,[
/* Servo #4,0   - TowerPro MG90D 15g                                              */
  [ 1, 28.5, 22.6,   12, 19.8, 6.00,    4, 2.25, 4.45,    0,    0,  1.6,    1,  2.5 ]
]

];


/* Bearing dimensions if needed.
 *
 *  [d, D, B]  =  [ internalDiameter, externalDiameter, thickness ]
 *
 * Set in servo_id the index of the servo needed.
 */
bearing_id	= 6;

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
   Options - External to servo dimensions
 */


/* Ears properties */

ear_support_screw	= 1;	/* for LEG_FORMAT=1, manage L-shaped block vertically screwed on
				 * the servo frame
				 * Modes:
				 *
				 *   0: no z-axis locking - classic for wing bottom skin strap mount
				 *   1: with a central notch in servo ear
				 *   2: with screws in servo ear
				 *   3: 1&2
				 *
				 */
ear_support_screwhead	= 3;	/* with ear_support_screw == 2, diameter of the screw head */

z_axis_servo_cover	= 1;	/* with ear_support_screw == 0, make a servo cover */


/* Servo arm properties */

arm_thickness		= 2;	/* Thickness of the servo arm, without the gear, only the arm */

arm_screw_head_dia	= 4;	/* (needed if 'with_bearing')
				 *
				 * 2 cases:
				 *
				 * - arm_screw_head_dia == bearing internal diameter
				 *    The screw head is used directly in the bearing
				 *    The bearing shaft produced is a spacer
				 *    to lock the servo arm in place.
				 *    => shorted screw needed.
				 *
				 * - arm_screw_head_dia != bearing internal diameter
				 *    The screw head is locking the bearing shaft externally.
				 *    The bearing shaft produced is entering in the bearing.
				 *    => longer screw needed.
				 *
				 */

/* Frame properties */

frame_thickness		= 1.5; 	/* thickness of the frame */

frame_extra_width	= 3.0; 	/* extra width of the frame */

frame_arm_clearance	= 3;    /* clearance between the servo arm top
				 * and the start of the servo frame top
				 * (aka bearing support if 'with_bearing').
				 *
				 * if 'with_bearing', this frame arm clearance is going to
				 * define the Arm screw length.
				 * In the console of openscad, for the current parameters,
				 * the arm screw length needed is displayed.
				 */

/* Bearing properties */

with_bearing 		= 3; 	/* 0: no bearing
				 * 1: With shaft bearing - Right
				 * 2: With shaft bearing - Left
				 * 3: With shaft bearing - Both - universal
				 */

/* MISC */

minkowski_rounded 	= 2;	/* rounded frame sphere */

$fn 			= 100;  /* Global circles segment number: 30 for design, >=100 for STL */


/*
 * Processing - internals and some spacers
 */

_servo_id_brand	= -1;
_servo_id_servo	= -1;


servo	= (_servo_id_brand>=0 && _servo_id_servo>=0)
	?
	servos_kb[_servo_id_brand][_servo_id_servo]	/* From commandline */
	:
	servos_kb[ servo_id[0] ][ servo_id[1] ];
bearing		= bearings_kb[ bearing_id ];

if (version_num() > 20180101)
	assert( servo, "MISSING SERVO DEFINITION");
else {
	if (! servo) echo("!!!! MISSING SERVO DEFINITION !!!!");
}


legformat		= servo[0];
s_h			= servo[1] 	+ 0.1;
s_w			= servo[2]	+ 0.1;
s_t			= servo[3];
s_h_ear			= servo[4]	+ 0.1;
s_w_gear		= servo[5];
s_gear_h		= servo[6];

s_ear_t			= (legformat)?servo[7]	+ 0.1 : 0;

s_ear_w			= (legformat)?servo[8]	+ 0.2 : 3;
s_ear_h			= (servo[9]?servo[9]:servo[8]) + 0.2;
s_ear_h_third		= (servo[10]?servo[10] + 0.2 : s_ear_h);
s_ear_isnotch		= (servo[11]<0) ? 1 : 0;
s_ear_hole_dia		= abs(servo[11]);
s_cable_h		= servo[12];
arm_screw_dia		= servo[13];

b_id			= bearing[0];
b_ed			= bearing[1] 	+ 0.2;
b_t			= bearing[2] 	+ 0.5;

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
_ear_support_screw	= (_check_arm_fail)? 0 : ear_support_screw;


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
			cube([s_w+s_ear_w*2,s_ear_t, s_t], center=true);
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
						translate([s_t/4,-s_t*3/4-s_ear_t/2,0]) {
							cube([s_t/2,s_t/2,s_w+s_ear_w*2],center=true);
						}
					}
					else {
						translate([0,-s_t/4-s_ear_t/2,0])
							cube([s_t,s_t/2,s_w+s_ear_w*2],center=true);
					}
				}
			}
			else {
				if (legformat && _ear_support_screw) {
					translate([0,-s_t/4-s_ear_t/2,0])
						cube([s_w+s_ear_w*2,s_t/2, s_t], center=true);
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
			difference()
			{
				rotate([0,90,0])
					scale([s_t,s_ear_w+frame_extra_width,1])
					cylinder(r=1,h=s_w,center=true);
				translate([0,0,-500])
					cube([1000,1000,1000],center=true);
				translate([0,500,0])
					cube([1000,1000,1000],center=true);
				nb=3;
				wall=(s_ear_w<4)?2:s_ear_w/2;
				cell=(s_w-wall*(nb+1))/nb;
				for(x=[-s_w/2+wall:cell+wall:s_w/2])
					translate([x+cell/2,-s_h/2-wall,0])
						cube([cell,s_h,1000],center=true);
			}
			/* no z-axis locking - adding a flat surface */
			if (_ear_support_screw == 0) {
				translate([0,-s_ear_w/2,s_t/2])
					cube([s_ear_w*2,s_ear_w,s_t],center=true);
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
			translate([ 0, s_h_ear - s_h/2 + s_ear_h/2, -(s_t/2-s_ear_t)/2])
				rotate([90,0,0])
				cube([s_w+s_ear_w*2+surround_spacer,
						s_t/2 - s_ear_t,
						s_ear_h+surround_spacer], center=true);
		}
		if (legformat==3) {
			translate([0, -s_h/2 - s_ear_w/2, masky/2])
				rotate([90,0,90])
				cube([s_ear_w*2,s_ear_t+masky, s_ear_h_third], center=true);
			if (issupport) {
				translate([0, -s_h/2 - s_ear_w/2, -(s_t/2-s_ear_t)/2])
					rotate([90,0,90])
					cube([s_ear_w+surround_spacer,
							s_t/2 - s_ear_t,
							s_ear_h_third+surround_spacer], center=true);
			}
		}
	}
}

module servo_cover() {
	if (_ear_support_screw == 0 && z_axis_servo_cover) {
		translate([0,-s_h/2-frame_extra_width-s_ear_w-1,-s_t/2]) {
			linear_extrude(1)
				polygon([
						[-s_w/2-s_ear_w,-s_ear_w*2], [-s_w/2-s_ear_w,0],
						[s_w/2+s_ear_w,0], [s_w/2+s_ear_w,-s_ear_w*2],
						[s_ear_w,-s_h_ear-s_ear_w],
						[-s_ear_w,-s_h_ear-s_ear_w]
				]);

		}
	}
}

module servo_ear_support_screw_solid() {
	if (legformat == 1 && _ear_support_screw) {
		translate([s_w/2, -s_t-s_h/2-s_ear_w-frame_extra_width - 1, -s_t/2]) {
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
	middlering = b_id+(b_ed-b_id)/2;
	locker_h   = (s_t - b_ed)/2 + b_ed/8;	/* locker lands at 1/8th of the bearing */
	if (issupport == 0) {
		if (locker == 0) {
			/* Bearing surround */
			translate([s_w/2-s_w_gear,s_h/2+(b_t*2)/2+frame_body_clearance,0]) {
				rotate([90,0,0]) {
					cylinder(r=middlering/2, h=b_t*2+1, center=true);
					translate([0,s_t/4,0]) cube([middlering,s_t/2,b_t*2+1],center=true);
				}
			}
			/* Bearing */
			translate([s_w/2-s_w_gear,s_h/2+frame_body_clearance,0]) {
				rotate([90,0,0]) {
					translate([0,0,-b_t]) {
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
						translate([0,s_t/2 - 1.5,0]) cube([s_w*10,3,b_t-b_t_clearance],center=true);
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

module servo_bearing_holder_screw_mask() {
	cylinder(r=.8,h=s_t, center=true, $fn=20);
	translate([0,0,s_t - 1.2])
		cube([b_t,b_t*1.5,s_t],center=true);
}

module servo_bearing_holder_wscrew( issupport=0, locker=0 ) {
	difference() {
		servo_bearing_holder( issupport, locker );
		translate([0,s_h/2+(b_t*2)/2+frame_body_clearance,0]) {
			servo_bearing_holder_screw_mask();
			translate([s_w-s_w_gear*2,0,0])
				servo_bearing_holder_screw_mask();
		}
	}
}

module servo_gear_solid( issupport=0 ) {
	translate([s_w/2-s_w_gear,s_h/2+s_gear_h/2,0]) {
		rotate([90,0,0])
		cylinder(r=2.75, h=s_gear_h, center=true);
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

module servo_cable_solid(y=0) {
	translate([0,-s_h/2+2 + s_cable_h,y/2])
		cube([1000,4,6+y], center=true);
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

		/* More mask */
		servo_cable_solid(100);
		if (legformat>1) {
			servo_ear_solid(100);
		}
		/* Servo gear clearance */
		translate([0, frame_body_clearance/2,0])
			/* Z: +2 for preview */
			cube([s_w, s_h+frame_body_clearance, s_t+2], center=true);
	}
}

/* Frame */


module frame_solid() {
	extra_width = frame_extra_width - minkowski_rounded;

	difference() {
		arm_clearance = frame_body_clearance;
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
		translate([-500,-500,-1000])
			cube([1000,1000,1000]);
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

		translate([-s_w/2, s_t+s_h/2+frame_body_clearance+frame_extra_width + 1, -s_t/2])
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
			cylinder( r = arm_screw_dia/2, h = 1000, center=true );
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
				frame_gear_clearance + cyl_visible + cyl_bearing + screw_bearing + 2,
				" and ",
				frame_body_clearance + cyl_visible + cyl_bearing + screw_bearing + 1, " mm");
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
		translate([s_w/2, s_t+s_h/2+frame_body_clearance+frame_extra_width, -s_t/2])
			rotate([90,0,0])
			translate([-frame_body_clearance,-b_t/2-frame_body_clearance-s_h/2,-s_t/2])
			intersection() {
				servo_bearing_holder_wscrew(1);
				servo_bearing_holder(0,1);
			}
	}
}

module servo_frame() {
	difference() {
		frame_w_ear_solid();
		servo_solid_mask();
	}
}

module servo_frame_parts() {
	servo_frame();
	servo_ear_support_screw();
	servo_cover();
	bearing_shaft_solid();
	bearing_lock_solid();
}


servo_frame_parts();

//servo_frame();


/*
 *
 * Wing Servo Frame configuration
 *
 */

servo_id	= [ 2, 2 ];   /* Brand,Servo  - list in servo-frame.scad */

bearing_id	= 1;           /* Bearing id   - list in servo-frame.scad */


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

arm_thickness		= .5;	/* It is the added thickness of the servo arm between the
				 * arm screw head (top of the threaded part) and the servo gear.
				 *
				 * With plastic arm, often low thickness, like .5 ~ 1 mm
				 * With aluminium arm, often higher thickness, like 1 ~ 2.5 mm
				 *
				 * If you don't know, take a secure value of .5mm so you will be
				 * able to trim/sand down the cone part if it is too big.
				 *
				 * You have to consider the servo arm height part which is covering
				 * the screw head and add it to the "frame_arm_clearance".
				 */

arm_screw_head_dia	= 3.8;	/* (needed if 'with_bearing')
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

frame_extra_width	= 4.0; 	/* extra width of the frame */

frame_arm_clearance	= 5;    /* clearance between the servo arm top (arm screw hole)
				 * and the start of the servo frame top
				 * (aka bearing support if 'with_bearing').
				 *
				 * See also 'arm_thickness' definition.
				 *
				 * if 'with_bearing', this frame arm clearance is going to
				 * define the Arm screw length.
				 * In the console of openscad, for the current parameters,
				 * the arm screw length needed is displayed.
				 */

frame_mode_light	= 0;	/* 0: solid frame
				 * 1: make holes in frame: lighter and probably enhance gluing
				 */

/* Bearing properties */

with_bearing 		= 0; 	/* 0: no bearing
				 * 1: With shaft bearing - Right
				 * 2: With shaft bearing - Left
				 * 3: With shaft bearing - Both - universal
				 */

/* Boxed? */
with_boxed		= 0;	/* 0: no box
				 * 1: with box
				 */
boxed_w			= 50;
boxed_l			= 50;
boxed_h			= 18;
boxed_thickness		= 0.8;
boxed_light		= 2;    /* 0: solid frame
				 * >0: make vertical notches in the box: lighter and release
				 *     tension during the print. Value is the width of the notch
				 */

/* MISC */

minkowski_rounded 	= 2;	/* rounded frame sphere */

$fn 			= 100;  /* Global circles segment number: 30 for design, >=100 for STL */


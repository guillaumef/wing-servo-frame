# wing-servo-frame

Wing servo frame - fully parametric - arms/bearing - servo database

### My 'ultimate' wing servo frame

- all servo ears format: 0-no_ear, 1-horizontal_ears, 2-vertical_ears, 3-vertical_three_ears
- parametric servo dimensions
- parametric bearing dimensions (like: MR83ZZ -> MR95ZZ ...)
- with or without external bearing (parametric bearing dimensions), left/right/both sides
- for horizontal ears, manage ear notch, screws or both
- many options (general thickness, arm clearance, frame round factor, ...)
- no added height to the servo thickness

Changelog is in the Scad file.

Documentation is in the Scad file.

Examples of generated STL in 'stl_examples' directory.

### Disclaimer

Nearly finished but I am still tweaking printing tolerances.

### Bearing and screw

It is easy to find, portable and far more cost-effective than commercial products and
proprietary arm screws.

The screw diameter (servo arm screw) must be inferior or equal to the bearing internal diameter.

##### Screw

The arm screw is replaced with a longer one.

Nearly all servo arm screws are M2,M2.5,M3.
A dissident is the KST X12, with M2.3 screw (nearly proprietary).
For this one, the simpliest way is a M2.5 tap set (flat tip or make it flatter), you get a strong M2.5 with 3.5mm depth.
You need M2,M2.5,M3 screws with a minimum length of 15mm and you are good to go for any servos.

##### Bearing

The scad file is generating the specified servo arm clearance (space between the
arm and the frame).
It is also generating the bearing shaft except for two special modes:
- if screw diameter is equal to bearing internal diameter: screw is automatically use as bearing shaft
- if screw head diameter is equal to bearing internal diameter: screw head is automatically use as bearing shaft

Bearing price is $2 for 10pcs, $8 for 50pcs... (aliexpress).

The servo frame accepts 8mm bearing even for 8mm servo.

To manage any kind of servos, choose your way:
- To get a full steel shaft, buy a bunch of them with 2mm,2.5mm,3mmm internal diameter. i.e:
  - MR52ZZ (2x5x2.5 mm)
  - 682XZZ (2.5x6x2.6 mm)
  - MR63ZZ (3x6x2.5 mm)
- To get a printed shaft, buy a bunch of 5mm internal diameter. i.e:
  - MR85ZZ (5x8x2.5)

##### Openscad feedback

The scad file is providing you information feedback on the screw/bearing.
Like this one:
```
ECHO: "******************"
ECHO: "Bearing shaft/arm screw:"
ECHO: "**** the shaft inserted in the bearing is printed"
ECHO: "**** screw length (threaded part) should be approximately between 15.5 and 18.3 mm"
ECHO: "**** >> Tuning the length is possible with the 'frame_arm_clearance' parameter"
ECHO: "**** screw thread metric is M3"
ECHO: "******************"
```
Or:
```
ECHO: "******************"
ECHO: "Bearing shaft/arm screw:"
ECHO: "**** 'arm_screw_dia' matches bearing internal diameter:"
ECHO: "**** >> the screw is the bearing shaft"
ECHO: "**** screw length (threaded part) should be approximately between 14.5 and 17.3 mm"
ECHO: "**** >> Tuning the length is possible with the 'frame_arm_clearance' parameter"
ECHO: "**** screw thread metric is M3"
ECHO: "******************"
```

### Usage

- Install OpenScad
- Edit the servo-frame.scad file to fit your needs (openscad preview can be tricked by the complexity, use F6 to render the final version if necessary)
- Generate the STL
- Print...

And as always, with or without frame, servo wings must use a thread-locking fluid for the arm screw.

### Printing

100% infill, ABS or Nylon material. Small layer printing is better.
On a Ultimaker2, ~ one servo frame per hour in good quality (layer 0.1mm).


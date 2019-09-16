# wing-servo-frame
Wing servo frame - fully parametric - arms/bearing - servo database


**My ultimate wing servo frame:**

- all servo ears format: 0-no_ear, 1-horizontal_ears, 2-vertical_ears, 3-vertical_three_ears
- parametric servo dimensions
- parametric bearing dimensions (like: MR83ZZ -> MR95ZZ)
- with or without external bearing (parametric bearing dimensions), left/right/both sides
- for horizontal ears, manage ear notch, screws or both
- many options (general thickness, arm clearance, frame round factor, ...)
- no added height to the servo thickness

(I am waiting to receive some bearings to test it and tweak the printing tolerance).

Changelog is in the Scad file.

Documentation is in the Scad file.

Examples of generated STL in 'stl_examples' directory.

**Disclaimer:**
Work in progress... there is issues with MKS range servo with ears and the Bluebird BMS-207.

**Bearing:**
If you activate the 'with_bearing' option, you will need:

- a bearing like the MR85ZZ on aliexpress ~ $2 for 10 pieces.
  (the servo frame accepts 8mm bearing even for 8mm servo)
- a screw... in the predefined servo list, you have the screw metric. Except for the KST X12 with M2.3, the screws are easy to find. If you have quality M2,M2.5,M3 screws with a minimum length of 10-12mm, you are good to go for any servos. You can find some screw sets anywhere.

There is special modes depending on bearing dimensions:
- if screw diameter is equal to bearing internal diameter: screw thread is automatically use as bearing shaft
- if screw head diameter is equal to bearing internal diameter: screw head is automatically use as bearing shaft

And as always, with or without frame, servo wings must use a thread-locking fluid for the arm screw.

**Usage:**

- Install OpenScad
- Edit the servo-frame.scad file to fit your needs (openscad preview can be tricked by the complexity, use F6 to render the final version if necessary)
- Generate the STL
- Print...

**Printing:**
100% infill, ABS or Nylon material. Small layer printing is better.
On a Ultimaker2, ~ one servo frame per hour in good quality (layer 0.1mm).


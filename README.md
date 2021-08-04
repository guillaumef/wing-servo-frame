# wing-servo-frame

Wing servo frame - fully parametric - arms/bearing - servo database

<img src="https://github.com/guillaumef/wing-servo-frame/blob/master/real/kingmax-cls0911w/pix03.jpg" width="300" alt="servo frame, servorahmen, Kingmax cls0911w, KST x10" align="center" />

<img src="https://github.com/guillaumef/wing-servo-frame/blob/master/assembly/p01-assembly.jpg" width="300" alt="wing servo frame" align="center" /><img src="https://github.com/guillaumef/wing-servo-frame/blob/master/assembly/p06-assembly.jpg" width="300" alt="wing servo frame" align="center" />

Videos (KST X08N, Bluebird BMS-125WV):

[<img src="https://img.youtube.com/vi/2ph3OZgdkxs/hqdefault.jpg" width="30%">](https://youtu.be/2ph3OZgdkxs) [<img src="https://img.youtube.com/vi/XQHXTqi7j4g/hqdefault.jpg" width="30%">](https://youtu.be/XQHXTqi7j4g)


[All animated gifs](GIFSHOW.md)


### Project description

- all servo ears format
- parametric servo dimensions
- parametric bearing dimensions (like: MR83ZZ -> MR95ZZ ...)
- with or without external bearing (also with parametric bearing dimensions), left/right/both sides
- for horizontal ears, manage ear notch, screws or both
- many options (general thickness, arm clearance, frame round factor, mode light, ...)
- no added height to the servo thickness

### Directories/files

- servo-frame.scad : OpenScad code and embedded documentation
- configuration.scad : Configuration and constants with embedded documentation
- Makefile : generate the STLs for all known servos
- stls : some auto-generated STLs for each servo in the KB (in some configurations)
- assembly : pictures and video of the assembly

### Usage

You need openscad and a text editor.

```
git clone https://github.com/guillaumef/wing-servo-frame.git
```

- Launch openscad on servo-frame.scad
- Edit the configuration.scad file to fit your needs (openscad preview can be a bit tricked by the complexity, use F6 to render the final version if necessary)
- Generate the STL
- Print...

### Bearing and screw

If you want a bearing and axial guidance, it is trivial.
Both are easy to find, portable and far more cost-effective than commercial products and
proprietary arm screws.

I am assembling at least one plane every year, I provisioned mixed bearing diameters and
screws for a few bucks.


##### Screw

The arm screw is replaced with a longer one.

Nearly all servo arm screws are M2,M2.5,M3.
The dissidents are the KST X series, KingMax CLS series, ... with M2.3 screw (hard to find).
Simply change it to M2.5 with a tap set (cost $5). This way, you get a strong M2.5 with 3.5mm depth.
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

### STLs directory

To ease the process, this directory provides multiple automatically generated STLs in some configurations:
- hollow / solid frame
- bearing: none/left/right/both

The configuration file is provided for each generated stl.
The bearing size is chosen for the best case scenario per servo: screw as the bearing shaft.

### Openscad feedback

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

##### Printing

100% infill, ABS or Nylon material. Small layer printing is better.
On a Ultimaker2, ~ one servo frame per hour in good quality (layer 0.1mm).

### Miscellaneous

- on carbon/fiberglass, use coarse grit sandpaper to roughen up the surfaces and
clean with acetone (NEVER on ABS)
- use a thread-locking fluid for the arm screw.
- for wings, add a strap (1-2mm Fiberglass, carbon) between the wing
top skin and the servo/frame. I quote the "Aeroic Schwing instructions":
This all ensures a ridgedly held servo. Servos that pop off do so because of flex in
the skins. Doing it this way there’s a lot of gluing area and no flex so the servo
cannot pop off. A weak glue joint with an unprepared servo is perfectly adequate.
The servo is held on the top skin, bottom skin and the head is held by the bearing
housing which itself is bonded to both skins! To remove just cut the strap, unbolt
the shaft and twist the servo. It pops out clean! But most of the time it may be you
just need to replace the arm. Then it’s even easier as you just unbolt the shaft and
leave the servo in situ.

### Servo database

If you add new servo dimensions to the list, I will be pleased to include them.
You can provide them via a Github Issue. Thanks!

Servo list:

- MKS DS6100 / HV6100
- MKS DS75K
- MKS DS75K-N
- MKS HV6130
- BlueBird BMS-125WV / BMS-126WV / BMS-127WV
- BlueBird BMS-207WV
- BlueBird BMS-115HV
- BlueBird BMS-A10S
- BlueBird BMS-A10V
- BlueBird BMS-A10H
- KST X12-508 HV
- KST X10 HV / DS125MG / DS225MG
- KST X10 MINI HV / DS135MG
- KST X10-710 HV / DS145MG
- KST X08 HV
- KST X08H HV
- KST X08N HV
- KST X08 Plus HV
- KST X08H Plus HV
- KST X06 HV
- KST X06H HV
- KST X06N HV
- KST HS08B HV
- KST HS08A HV
- Emax ES3352
- Emax ES08MDII
- TowerPro MG90D 15g
- KingMax CLS0911W
- KingMax CLS0612W

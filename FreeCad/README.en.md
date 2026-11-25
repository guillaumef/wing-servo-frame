# Wing Servo Frame for FreeCAD

[🇫🇷 Français](README.md) · 🇬🇧 English

A FreeCAD macro that generates a **servo frame** for model aircraft wings, with a bearing support on the servo arm axis, retaining ears, a cover, an optional box and a seat for threaded **Ruthex** inserts.

All settings live in a FreeCAD spreadsheet: change a value, recompute, and the parts regenerate.

This is a Python/FreeCAD conversion of the OpenSCAD project `servo-frame.scad` by Guillaume F. (GPL license). The parameters of his `configuration.scad` are found in the `Config` sheet.

## Contents

1. [Installation](#1-installation)
2. [Usage](#2-usage)
3. [Generated parts](#3-generated-parts)
4. [Config sheet parameters](#4-config-sheet-parameters)
5. [Databases: Servos, Bearings, Ruthex](#5-databases-servos-bearings-ruthex)
6. [Ruthex inserts](#6-ruthex-inserts)
7. [STL export](#7-stl-export)
8. [Troubleshooting](#8-troubleshooting)
9. [Compatibility and credits](#9-compatibility-and-credits)

---

## 1. Installation

1. Install [FreeCAD](https://www.freecad.org/downloads.php).
2. Download the file **`servo_frame_freecad.py`** from this repository (*Download raw file* button, or clone the repository).
3. Copy it into your **FreeCAD macro folder**. To find it: *Edit → Preferences → General → Macro*, "Macro path" field. Usual locations:

   | System | Folder |
   |---|---|
   | Windows | `%APPDATA%\FreeCAD\Macro\` |
   | Linux | `~/.local/share/FreeCAD/Macro/` |
   | macOS | `~/Library/Application Support/FreeCAD/Macro/` |

4. In FreeCAD, open *Macro → Macros…*: `servo_frame_freecad` appears in the list.

**Without installing:** simply open the `.py` file in FreeCAD (*File → Open*), then run *Macro → Execute macro* (Ctrl+F6).

## 2. Usage

### First generation

1. Start FreeCAD and create an empty document (or create nothing: the macro creates one named `WingServoFrame`).
2. *Macro → Macros…*, select `servo_frame_freecad`, click **Execute**.
3. The macro creates in the document:
   - **4 spreadsheets**: `Config` (your settings), `Servos`, `Bearings` and `Ruthex` (the databases);
   - **5 parts** (see [section 3](#3-generated-parts)), already laid out side by side, ready to print.

With the default values, the servo is a KingMax CLS0911W with a 682XZZ bearing on the right.

### Changing the configuration

1. Open the `Config` sheet (double-click in the tree).
2. Edit the values in **column B** (yellow cells). Column C describes each parameter.
3. Recompute the document: **Ctrl+R** (*Recompute* button). The parts regenerate.

### Messages in the report view

Open *View → Panels → Report view* to read:
- the recommended **screw length** for the servo arm when a bearing is used (adjustable with `frame_arm_clearance`);
- warnings (automatic fallback of `ear_support_screw`, Ruthex ignored…).

### Saving and reopening

Save the document normally (`.FCStd`). When reopened, the shapes are kept but **automatic recompute is no longer active**: run the macro again (it reconnects the parts to the existing document without overwriting anything), then edit `Config` as before.

## 3. Generated parts

| Object | Content | Present when |
|---|---|---|
| `ServoFrame` | The main frame with its ears and bearing supports | always |
| `EarSupportScrew` | The two L-shaped blocks that lock the servo ears | servo `LEG_FORMAT` 1 and `ear_support_screw` > 0 |
| `ServoCover` | Servo cover | `ear_support_screw` = 0 and `z_axis_servo_cover` = 1 |
| `BearingShaft` | Shaft that goes into the bearing (or spacer) | `with_bearing` > 0 |
| `BearingLock` | Bearing lock | `with_bearing` > 0 |

A part that does not apply stays empty: this is not an error.

## 4. Config sheet parameters

### Servo and bearing

| Parameter | Default | Description |
|---|---|---|
| `servo_brand` | 5 | Servo brand: column A of the `Servos` sheet. |
| `servo_index` | 0 | Servo number within the brand: column B of the `Servos` sheet. Default: brand 5, servo 0 = KingMax CLS0911W. |
| `bearing_id` | 1 | Bearing to use: column A of the `Bearings` sheet. The servo arm screw diameter (column M of `Servos`) must not exceed the bearing's inner diameter. |

### Ears

| Parameter | Default | Description |
|---|---|---|
| `ear_support_screw` | 1 | For `LEG_FORMAT` 1 servos (horizontal ears): manages the L-shaped blocks screwed vertically onto the frame. **0**: no Z-axis locking (classic mount with a strap under the wing's bottom skin); **1**: with a central notch in the servo ear; **2**: with screws in the servo ear; **3**: 1 and 2 together. If there is not enough room between the cable and the ear, the macro falls back to 0 and reports it. |
| `ear_support_screwhead` | 3 | With `ear_support_screw` = 2: screw head diameter (mm). |
| `z_axis_servo_cover` | 1 | With `ear_support_screw` = 0: makes a servo cover (0 = no, 1 = yes). |
| `ruthex_id` | 0 | Ruthex insert to press into the ears: id from the `Ruthex` sheet. **0 = no insert.** See [section 6](#6-ruthex-inserts). |
| `ruthex_extra_depth` | 0 | Extra material below the insert, in addition to its length L (mm). |

### Servo arm

| Parameter | Default | Description |
|---|---|---|
| `arm_thickness` | 0.5 | Added thickness of the servo arm between the arm screw head (top of the threaded part) and the servo gear (mm). Plastic arm: often 0.5 to 1 mm. Aluminium arm: often 1 to 2.5 mm. If in doubt, use 0.5 mm: you can always sand down the cone if it is too big. |
| `arm_screw_head_dia` | 4.4 | Diameter of the arm screw head (useful with a bearing). If it is **equal to the bearing's inner diameter**, the screw head works directly in the bearing and the printed part is only a spacer (shorter screw). If it is **different**, the screw head locks the printed shaft from the outside, and the shaft goes into the bearing (longer screw). |

### Frame

| Parameter | Default | Description |
|---|---|---|
| `frame_thickness` | 1.5 | Frame thickness (mm). |
| `frame_extra_width` | 1.5 | Extra frame width around the servo (mm). |
| `frame_arm_clearance` | 5.0 | Clearance between the top of the servo arm (screw hole) and the start of the top of the frame (bearing support when `with_bearing`). With a bearing, this parameter sets the arm screw length, displayed in the report view. |
| `frame_mode_light` | 1 | **0**: solid frame. **1**: frame with holes, lighter and probably better for gluing. |

### Bearing

| Parameter | Default | Description |
|---|---|---|
| `with_bearing` | 1 | **0**: no bearing. **1**: bearing on the right. **2**: bearing on the left. **3**: both sides (universal). |

### Box

| Parameter | Default | Description |
|---|---|---|
| `with_boxed` | 0 | 0 = no box, 1 = box around the servo. |
| `boxed_w` | 50 | Box width (mm). |
| `boxed_l` | 50 | Box length (mm). |
| `boxed_h` | 18 | Box height (mm). |
| `boxed_thickness` | 0.8 | Box wall thickness (mm). |
| `boxed_light` | 2 | **0**: solid walls. **> 0**: vertical notches in the box, which lighten it and release tension during printing; the value is the notch width (mm). |

### Misc

| Parameter | Default | Description |
|---|---|---|
| `minkowski_rounded` | 1.5 | Corner rounding radius of the frame (mm). |
| `fn_segments` | 150 | Equivalent of OpenSCAD's `$fn`. FreeCAD works with exact circles: this parameter only sets the **mesh fineness for STL export** (30 is enough to preview, 100 or more for printing). |

## 5. Databases: Servos, Bearings, Ruthex

These sheets are **read by the macro**: editing or adding a row is enough.

### `Servos` sheet

One row per servo: `Marque` (brand), `Index`, `Nom` (name), then 14 dimension columns (mm). The macro looks for the row whose brand and index match `servo_brand` and `servo_index`. It contains **35 servos** (MKS, BlueBird, KST, Emax, TowerPro, KingMax, GDW).

| Column | Meaning |
|---|---|
| `LEG_FORMAT` | Ear type: **0** no ears, **1** horizontal ears, **2** vertical ears, **3** three vertical ears |
| `A` | Body height (servo bottom to gear root) |
| `B` | Body width (without ears) |
| `C` | Body thickness |
| `D` | Ear position (servo bottom to ear bottom) |
| `E` | Gear center to body side (the smallest one) |
| `F` | Gear height |
| `G` | Ear thickness |
| `H` | Ear width |
| `I` | Ear height (vertical ears; 0 = ear width) |
| `J` | With three ears: width of the rear ear. Otherwise: height of the rear notch for external-motor servos |
| `K` | Ear hole: **negative** value = notch, **positive** value = hole (diameter) |
| `L` | Cable position (servo bottom to cable bottom) |
| `M` | Gear screw diameter (required if `with_bearing`) |

**Adding a servo:** add a row at the end of the table, with no empty row between servos (reading stops at the first empty cell in column A), using a brand and index pair that does not already exist. Measure the servo with a caliper.

### `Bearings` sheet

Columns: `Id`, `Nom` (name), `d` (inner diameter), `D` (outer diameter), `B` (thickness). 8 bearings, from MR52ZZ to MR95ZZ. `bearing_id` refers to the `Id`.

### `Ruthex` sheet

Columns: `Id`, `Nom` (name), `d1`, `d2`, `d3`, `L`, `W`. 19 inserts, plus id 0 reserved for "no insert". See the next section.

## 6. Ruthex inserts

With `ruthex_id` other than 0, the macro:

1. **drills through-holes** with a diameter of **d3 + 0.2 mm** (0.2 mm of functional clearance) at the center of each ear;
2. **thickens the frame under the ears** so that the material under the insert is at least as deep as its length **L** (+ `ruthex_extra_depth`).

Where the holes are drilled:

| `LEG_FORMAT` | Holes | Axis |
|---|---|---|
| 1 (horizontal ears) | 2 (one per ear) | Y — **only if `ear_support_screw` = 0** |
| 2 (vertical ears) | 2 (one per ear) | Z |
| 3 (three ears) | 3 (two side ears + the rear ear) | Z |
| 0 (no ears) | none | a warning is displayed |

With `LEG_FORMAT` 1 and `ear_support_screw` > 0, the space under the ear is occupied by the L-shaped block: the Ruthex is then ignored, with a warning in the report view.

**Frame bottom:** as soon as L exceeds about 4 mm, the frame extends below the original plane, under the ears. The bottom is no longer flat there: take this into account for print orientation.

| Id | Name | d3 (mm) | L (mm) |
|---|---|---|---|
| 0 | None (no insert) | — | — |
| 1 | M2 / #2-56 | 3.2 | 4.0 |
| 2 | #4-40 Short | 4.0 | 3.56 |
| 3 | M2.5 | 4.0 | 5.7 |
| 4 | M3 Short | 4.0 | 4.0 |
| 5 | M3x5x4 Voron | 4.4 | 4.0 |
| 6 | M3 / #4-40 | 4.0 | 5.7 |
| 7 | #6-32 Short | 4.8 | 3.8 |
| 8 | #6-32 | 4.8 | 7.1 |
| 9 | M4 Short | 5.6 | 4.0 |
| 10 | #8-32 Short | 5.6 | 4.7 |
| 11 | M4 / #8-32 | 5.6 | 8.1 |
| 12 | M5 Short | 6.4 | 5.8 |
| 13 | M5 / #10-24 / #10-32 UNF | 6.4 | 9.5 |
| 14 | 1/4in-20 Short | 8.0 | 6.4 |
| 15 | M6 / 1/4in-20 | 8.0 | 12.7 |
| 16 | M6 Short | 8.0 | 6.8 |
| 17 | M8 / 5/16in-18 | 9.6 | 12.7 |
| 18 | 3/8in-16 | 11.9 | 12.7 |
| 19 | M10 | 12.0 | 12.7 |

The full dimensions (d1, d2, d3, L, W) are in the `Ruthex` sheet, taken from the manufacturer's table.

## 7. STL export

**From the interface:** select the parts to export in the tree, then *File → Export…* and choose the STL format.

**From the Python console** (mesh controlled by `fn_segments`):

```python
exec(open("/path/to/servo_frame_freecad.py", encoding="utf-8").read())
export_stl("/path/to/a/folder")
```

One `.stl` file is created per non-empty part.

## 8. Troubleshooting

| Message or symptom | Cause and solution |
|---|---|
| `Servo introuvable (marque X, index Y)` | No row of the `Servos` sheet matches `servo_brand` / `servo_index`. |
| `Roulement introuvable` / `Ruthex introuvable` | `bearing_id` or `ruthex_id` is missing from the corresponding sheet. |
| `BEARING INTERNAL DIAMETER inferior to SCREW DIAMETER` | The servo screw (column M) is larger than the chosen bearing: pick a bearing with an inner diameter ≥ that diameter, or set `with_bearing` to 0. |
| Parts shown in red or "Touched" after an edit | Press **Ctrl+R**. If the error persists, read the report view. |
| A part is empty | Normal if it does not apply (see [section 3](#3-generated-parts)). |
| No recompute after reopening the document | Run the macro again. |
| The `ruthex_id` row is missing from `Config` in an old document | Delete the `Config` sheet and run the macro again, or add the row by hand with the alias `ruthex_id`. |

The macro's error messages (`Servo introuvable`, `Roulement introuvable`, `Ruthex introuvable`) are in French.

## 9. Compatibility and credits

- Developed and tested with **FreeCAD 26.3**. Other versions have not been tested.
- Checked against OpenSCAD on 9 configurations (all ear formats, with and without bearing, cover, box): same dimensions, volumes within about 0.2 %.
- Original project: **Wing Servo Frame**, Guillaume F., GPL license.
- License of this macro: **GPL**, like the original project.

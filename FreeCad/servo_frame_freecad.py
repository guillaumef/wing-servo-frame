# -*- coding: utf-8 -*-
"""
WING SERVO FRAME - version FreeCAD (macro Python)

Conversion de servo-frame.scad (Guillaume F. - licence GPL) vers FreeCAD.
Les paramètres de configuration.scad sont dans une feuille de calcul « Config ».
La base de servos, de roulements et d'inserts Ruthex est dans les feuilles « Servos », « Bearings » et « Ruthex ».

Utilisation :
  1. FreeCAD > Macro > Macros... > (ou ouvrir ce fichier) > Exécuter.
     Le script crée le document, les 3 feuilles et les 5 pièces.
  2. Modifiez les valeurs de la feuille « Config » (colonne B), puis Ctrl+R
     (Recalculer) : les pièces se régénèrent.
     Si le recalcul automatique ne se déclenche pas (document rouvert, macro
     non rechargée), relancez simplement la macro.
  3. Export STL : export_stl("/chemin/dossier")  (voir fin du fichier).

Pièces produites (déjà disposées comme dans le .scad, prêtes à imprimer) :
  ServoFrame, EarSupportScrew, ServoCover, BearingShaft, BearingLock
"""

import math
import FreeCAD
import Part
import Spreadsheet  # noqa: F401  (charge le module Spreadsheet)

V = FreeCAD.Vector

PART_NAMES = ("ServoFrame", "EarSupportScrew", "ServoCover", "BearingShaft", "BearingLock")

# ----------------------------------------------------------------------------
# Bases de données (équivalent de servos_kb et bearings_kb)
# ----------------------------------------------------------------------------
BRANDS = {
    0: "MKS",
    1: "BlueBird",
    2: "KST",
    3: "Emax",
    4: "TowerPro",
    5: "KingMax",
    6: "GDW",
}

# (marque, index): ("nom", [LEG, A, B, C, D, E, F, G, H, I, J, K, L, M])
SERVOS = {
    (0, 0): ("MKS DS6100 / HV6100", [1, 20, 22.5, 10, 15.1, 4.75, 4.5, 1.2, 4.25, 0, 0, 2, 0, 2.5]),
    (0, 1): ("MKS DS75K", [1, 16.7, 23, 9, 8.7, 4.8, 3.35, 1.2, 3, 0, 0, 2, 0, 2.5]),
    (0, 2): ("MKS DS75K-N", [0, 16.7, 23, 9, 12, 4.8, 3.35, 0, 0, 0, 0, 0, 0, 2.5]),
    (0, 3): ("MKS HV6130", [2, 29.5, 30, 10, 19.8, 6.5, 2.8, 2, 6, 8, 0, 3, 2, 2.5]),
    (1, 0): ("BlueBird BMS-125WV / BMS-126WV / BMS-127WV", [1, 20, 23.2, 10, 15, 5.43, 3.8, 1.3, 4.6, 0, 0, -2, 0, 3]),
    (1, 1): ("BlueBird BMS-207WV", [1, 27.5, 23, 12, 20.1, 5.7, 3.8, 2, 4.75, 0, 0, -2, 6, 3]),
    (1, 2): ("BlueBird BMS-115HV", [2, 20, 23.2, 10, 12.5, 5.43, 3.8, 1.2, 4.6, 7, 0, -2, 0, 3]),
    (1, 3): ("BlueBird BMS-A10S", [0, 21, 22, 8, 15, 5.1, 3.45, 0, 0, 0, 0, 0, 0, 2]),
    (1, 4): ("BlueBird BMS-A10V", [2, 21, 22, 8, 14.1, 5.1, 3.45, 1, 3, 5, 0, 1.8, 0, 2]),
    (1, 5): ("BlueBird BMS-A10H", [1, 21, 22, 8, 15.1, 5.1, 3.45, 1, 3, 0, 0, -2, 0, 2]),
    (2, 0): ("KST X12-508 HV", [1, 26.6, 23, 12, 19.9, 5.8, 3.5, 1.2, 4.5, 0, 0, -2, 5.25, 2.5]),
    (2, 1): ("KST X10 HV / DS125MG / DS225MG", [3, 35.5, 30, 10, 27.5, 6.6, 3.3, 1.8, 6, 8, 10.1, 3, 14.5, 2.5]),
    (2, 2): ("KST X10 MINI HV / DS135MG", [3, 29.6, 30, 10, 21.6, 6.6, 3.3, 1.8, 6, 8, 10.1, 3, 10.5, 2.5]),
    (2, 3): ("KST X10-710 HV / DS145MG", [1, 29.6, 30, 10, 21.6, 6.6, 3.3, 1.9, 6, 0, 0, 3, 8, 2.5]),
    (2, 4): ("KST X08 HV", [1, 21, 23.5, 8, 14.9, 6.13, 2.9, 1, 3, 0, 0, 2, 0, 2]),
    (2, 5): ("KST X08H HV", [2, 21, 23.5, 8, 14.9, 6.1, 2.9, 1, 3, 4, 0, 1.6, 0, 2]),
    (2, 6): ("KST X08N HV", [0, 21, 23.5, 8, 14.9, 6.13, 2.9, 0, 0, 0, 0, 0, 0, 2]),
    (2, 7): ("KST X08 Plus HV", [1, 27.3, 23.5, 8, 21, 6.13, 2.9, 1, 3, 0, 0, 2, 0, 2]),
    (2, 8): ("KST X08H Plus HV", [2, 27.3, 23.5, 8, 21, 6.1, 2.9, 1, 3, 4, 0, 1.6, 0, 2]),
    (2, 9): ("KST X06 HV", [1, 16.6, 20, 7, 11.9, 5, 2.7, 1, 4, 0, 0, 2, 0, 2]),
    (2, 10): ("KST X06H HV", [2, 16.6, 20, 7, 8.9, 5, 2.7, 1, 3, 4, 0, 1.6, 0, 2]),
    (2, 11): ("KST X06N HV", [0, 16.6, 20, 7, 11.9, 5, 2.7, 0, 0, 0, 0, 0, 0, 2]),
    (2, 12): ("KST HS08B HV", [1, 25.3, 23.5, 8, 19, 6.11, 3.2, 1, 3, 0, 0, 2, 0, 2]),
    (2, 13): ("KST HS08A HV", [2, 25.3, 23.5, 8, 19, 6.11, 3.2, 1, 3, 4, 0, 1.6, 0, 2]),
    (2, 14): ("KST A08N", [0, 19.0, 23.5, 8, 12.9, 5.85, 2.7, 0, 0, 0, 0, 0, 0, 2]),
    (2, 15): ("KST A08", [1, 19.0, 23.5, 8, 12.9, 5.85, 2.7, 1, 3, 0, 0, 2, 0, 2]),
    (2, 16): ("KST A08H", [2, 19.0, 23.5, 8, 12.9, 5.85, 2.7, 1, 3, 4, 0, 2, 0, 2]),
    (3, 0): ("Emax ES3352", [1, 25.88, 23.17, 9.3, 17.25, 4.47, 3.4, 2.0, 4.6, 0, 0, 2.0, 2.6, 2]),
    (3, 1): ("Emax ES08MDII", [1, 24, 23.85, 11.8, 15, 5.42, 3.4, 1.65, 4.16, 0, 0, 2.0, 1, 2]),
    (4, 0): ("TowerPro MG90D 15g", [1, 28.5, 22.6, 12, 19.8, 6.0, 4, 2.25, 4.45, 0, 0, 1.6, 1, 2.5]),
    (5, 0): ("KingMax CLS0911W", [3, 35.5, 30, 10, 27.25, 6.5, 3.2, 2.0, 6, 8, 10.0, 3, 14.0, 2.5]),
    (5, 1): ("KingMax CLS0612W", [3, 30, 30, 10, 22, 6.5, 3.2, 2.0, 6, 8, 10.0, 3, 8.5, 2.5]),
    (5, 2): ("KingMax C507", [2, 23.4, 23.5, 8, 15.1, 5.9, 2.7, 1.5, 3, 4.7, 3.3, 1.8, 0, 2]),
    (6, 0): ("GDW DS1906-A", [2, 23.5, 23.5, 8, 15.5, 5.4, 3.2, 1.1, 3, 3.8, 3.5, 1.5, 0, 2]),
    (6, 1): ("GDW DS1906-B", [1, 23.5, 23.5, 8, 15.5, 5.4, 3.2, 1.1, 3, 0, 0, 1.5, 0, 2]),
}

# id: ("nom", [d_interne, D_externe, epaisseur])
BEARINGS = {
    0: ("MR52ZZ L-520ZZ", [2, 5, 2.5]),
    1: ("682XZZ", [2.5, 6, 2.6]),
    2: ("MR63ZZ L-630ZZ", [3, 6, 2.5]),
    3: ("MR83ZZ", [3, 8, 3]),
    4: ("MR93ZZ", [3, 9, 4]),
    5: ("MR84ZZ", [4, 8, 3]),
    6: ("MR85ZZ", [5, 8, 2.5]),
    7: ("MR95ZZ", [5, 9, 3]),
}

# Inserts filetés Ruthex (source : tableau « Größe » du fabricant)
#   id: ("nom", [d1, d2, d3, L, W])   - id 0 réservé = pas d'insert
#   d1 = Ø extérieur de l'insert, d2 = Ø de perçage, d3 = Ø d3 du plan, L = longueur, W = valeur W du tableau
RUTHEX = {
    0: ("Aucun (pas d'insert)", [0, 0, 0, 0, 0]),
    1: ("M2 / #2-56", [3.6, 3.1, 3.2, 4.0, 1.3]),
    2: ("#4-40 Short", [4.6, 3.9, 4.0, 3.56, 1.6]),
    3: ("M2.5", [4.6, 3.9, 4.0, 5.7, 1.6]),
    4: ("M3 Short", [4.6, 3.9, 4.0, 4.0, 1.6]),
    5: ("M3x5x4 Voron", [5.0, 4.25, 4.4, 4.0, 1.3]),
    6: ("M3 / #4-40", [4.6, 3.9, 4.0, 5.7, 1.6]),
    7: ("#6-32 Short", [5.4, 4.7, 4.8, 3.8, 1.8]),
    8: ("#6-32", [5.4, 4.7, 4.8, 7.1, 1.8]),
    9: ("M4 Short", [6.3, 5.5, 5.6, 4.0, 2.1]),
    10: ("#8-32 Short", [6.3, 5.5, 5.6, 4.7, 2.1]),
    11: ("M4 / #8-32", [6.3, 5.5, 5.6, 8.1, 2.1]),
    12: ("M5 Short", [7.1, 6.3, 6.4, 5.8, 2.6]),
    13: ("M5 / #10-24 / #10-32 UNF", [7.1, 6.3, 6.4, 9.5, 2.6]),
    14: ("1/4in-20 Short", [8.7, 7.9, 8.0, 6.4, 3.3]),
    15: ("M6 / 1/4in-20", [8.7, 7.9, 8.0, 12.7, 3.3]),
    16: ("M6 Short", [8.7, 7.9, 8.0, 6.8, 3.3]),
    17: ("M8 / 5/16in-18", [10.1, 9.5, 9.6, 12.7, 4.5]),
    18: ("3/8in-16", [12.6, 11.8, 11.9, 12.7, 6.0]),
    19: ("M10", [12.6, 11.8, 12.0, 12.7, 6.0]),
}

SERVO_COLUMNS = ["LEG_FORMAT", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"]

# ----------------------------------------------------------------------------
# Paramètres de configuration (équivalent de configuration.scad)
#   (alias, valeur, description)   - un tuple à 1 élément = titre de section
# ----------------------------------------------------------------------------
CONFIG = [
    ("Servo et roulement",),
    ("servo_brand", 5, "Marque du servo (voir feuille Servos, colonne A)"),
    ("servo_index", 0, "Numéro du servo dans la marque (feuille Servos, colonne B)"),
    ("bearing_id", 1, "Id du roulement (feuille Bearings, colonne A)"),

    ("Oreilles (ears)",),
    ("ear_support_screw", 1, "LEG_FORMAT=1 : bloc en L vissé. 0=aucun blocage z (sangle) 1=encoche centrale 2=vis dans l'oreille 3=1+2"),
    ("ear_support_screwhead", 3, "Si ear_support_screw=2 : diamètre de la tête de vis"),
    ("z_axis_servo_cover", 1, "Si ear_support_screw=0 : fabrique un couvercle de servo (0/1)"),
    ("ruthex_id", 0, "Insert Ruthex à presser dans les oreilles : id de la feuille Ruthex. 0 = pas d'insert"),
    ("ruthex_extra_depth", 0.0, "Matière en plus de la longueur L de l'insert, sous l'insert (mm). Le cadre est épaissi sous les oreilles pour atteindre L + cette valeur"),

    ("Palonnier (servo arm)",),
    ("arm_thickness", 0.5, "Épaisseur ajoutée du palonnier entre la tête de vis et l'engrenage (mm)"),
    ("arm_screw_head_dia", 4.4, "Diamètre de la tête de vis du palonnier (utile si with_bearing)"),

    ("Cadre (frame)",),
    ("frame_thickness", 1.5, "Épaisseur du cadre (mm)"),
    ("frame_extra_width", 1.5, "Largeur supplémentaire du cadre (mm)"),
    ("frame_arm_clearance", 5.0, "Dégagement entre le haut du palonnier et le début du cadre (définit la longueur de vis)"),
    ("frame_mode_light", 1, "0 = cadre plein, 1 = cadre ajouré (plus léger, meilleur collage)"),

    ("Roulement (bearing)",),
    ("with_bearing", 1, "0=sans 1=avec roulement à droite 2=à gauche 3=des deux côtés"),

    ("Boîtier (boxed)",),
    ("with_boxed", 0, "0 = sans boîtier, 1 = avec boîtier"),
    ("boxed_w", 50, "Largeur du boîtier (mm)"),
    ("boxed_l", 50, "Longueur du boîtier (mm)"),
    ("boxed_h", 18, "Hauteur du boîtier (mm)"),
    ("boxed_thickness", 0.8, "Épaisseur des parois du boîtier (mm)"),
    ("boxed_light", 2, "0 = plein, >0 = encoches verticales (valeur = largeur de l'encoche)"),

    ("Divers (misc)",),
    ("minkowski_rounded", 1.5, "Rayon d'arrondi du cadre (équivalent de la sphère de Minkowski)"),
    ("fn_segments", 150, "$fn : segments des cercles. Sert à la finesse du maillage à l'export STL"),
]


def _num(v):
    """Convertit une valeur de cellule FreeCAD (float, int, Quantity) en nombre."""
    if hasattr(v, "Value"):
        v = v.Value
    return v


def sget(sheet, ref, default=None):
    """Lit une cellule ou un alias ; renvoie default si vide."""
    try:
        return _num(sheet.get(ref))
    except Exception:
        return default


def _text(s):
    return "'" + str(s)  # le ' force le type texte dans une cellule


def create_config_sheet(doc):
    sh = doc.addObject("Spreadsheet::Sheet", "Config")
    sh.Label = "Config"
    sh.set("A1", _text("Paramètre"))
    sh.set("B1", _text("Valeur"))
    sh.set("C1", _text("Description"))
    r = 2
    for item in CONFIG:
        if len(item) == 1:
            sh.set("A%d" % r, _text(item[0]))
            sh.setStyle("A%d:C%d" % (r, r), "bold", "add")
            sh.setBackground("A%d:C%d" % (r, r), (0.82, 0.88, 0.95, 1.0))
        else:
            alias, value, desc = item
            sh.set("A%d" % r, _text(alias))
            sh.set("B%d" % r, str(value))
            sh.setAlias("B%d" % r, alias)
            sh.set("C%d" % r, _text(desc))
            sh.setBackground("B%d" % r, (1.0, 0.95, 0.75, 1.0))
        r += 1
    sh.setStyle("A1:C1", "bold", "add")
    sh.setColumnWidth("A", 170)
    sh.setColumnWidth("B", 80)
    sh.setColumnWidth("C", 620)
    return sh


def create_servos_sheet(doc):
    sh = doc.addObject("Spreadsheet::Sheet", "Servos")
    sh.Label = "Servos"
    heads = ["Marque", "Index", "Nom"] + SERVO_COLUMNS
    for c, h in enumerate(heads):
        sh.set("%s1" % _col(c), _text(h))
    sh.setStyle("A1:Q1", "bold", "add")
    r = 2
    for (b, i), (name, vals) in sorted(SERVOS.items()):
        sh.set("A%d" % r, str(b))
        sh.set("B%d" % r, str(i))
        sh.set("C%d" % r, _text(name))
        for c, v in enumerate(vals):
            sh.set("%s%d" % (_col(3 + c), r), str(v))
        r += 1
    sh.setColumnWidth("C", 300)
    return sh


def create_bearings_sheet(doc):
    sh = doc.addObject("Spreadsheet::Sheet", "Bearings")
    sh.Label = "Bearings"
    for c, h in enumerate(["Id", "Nom", "d (interne)", "D (externe)", "B (épaisseur)"]):
        sh.set("%s1" % _col(c), _text(h))
    sh.setStyle("A1:E1", "bold", "add")
    r = 2
    for i, (name, vals) in sorted(BEARINGS.items()):
        sh.set("A%d" % r, str(i))
        sh.set("B%d" % r, _text(name))
        for c, v in enumerate(vals):
            sh.set("%s%d" % (_col(2 + c), r), str(v))
        r += 1
    sh.setColumnWidth("B", 200)
    return sh


def create_ruthex_sheet(doc):
    sh = doc.addObject("Spreadsheet::Sheet", "Ruthex")
    sh.Label = "Ruthex"
    for c, h in enumerate(["Id", "Nom", "d1 (ext.)", "d2 (perçage)", "d3", "L (longueur)", "W"]):
        sh.set("%s1" % _col(c), _text(h))
    sh.setStyle("A1:G1", "bold", "add")
    r = 2
    for i, (name, vals) in sorted(RUTHEX.items()):
        sh.set("A%d" % r, str(i))
        sh.set("B%d" % r, _text(name))
        for c, v in enumerate(vals):
            sh.set("%s%d" % (_col(2 + c), r), str(v))
        r += 1
    sh.setColumnWidth("B", 220)
    return sh


def _col(c):
    return "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[c]


def read_inputs(config_sheet, servos_sheet, bearings_sheet, ruthex_sheet=None):
    """Lit les feuilles et renvoie (cfg, servo, bearing, ruthex). ruthex = None si ruthex_id = 0."""
    cfg = {}
    for item in CONFIG:
        if len(item) == 3:
            cfg[item[0]] = sget(config_sheet, item[0], item[1])

    brand, index = int(cfg["servo_brand"]), int(cfg["servo_index"])
    servo = None
    for r in range(2, 400):
        b = sget(servos_sheet, "A%d" % r)
        if b is None:
            break
        if int(b) == brand and int(sget(servos_sheet, "B%d" % r)) == index:
            servo = [sget(servos_sheet, "%s%d" % (_col(3 + c), r), 0) for c in range(14)]
            break
    if servo is None:
        raise ValueError("Servo introuvable (marque %d, index %d) dans la feuille Servos" % (brand, index))

    bid = int(cfg["bearing_id"])
    bearing = None
    for r in range(2, 100):
        b = sget(bearings_sheet, "A%d" % r)
        if b is None:
            break
        if int(b) == bid:
            bearing = [sget(bearings_sheet, "%s%d" % (_col(2 + c), r), 0) for c in range(3)]
            break
    if bearing is None:
        raise ValueError("Roulement introuvable (id %d) dans la feuille Bearings" % bid)

    ruthex = None
    rid = int(cfg.get("ruthex_id", 0) or 0)
    if rid != 0:
        if ruthex_sheet is None:
            raise ValueError("Feuille Ruthex absente : relancez la macro pour la créer")
        for r in range(2, 100):
            b = sget(ruthex_sheet, "A%d" % r)
            if b is None:
                break
            if int(b) == rid:
                ruthex = [sget(ruthex_sheet, "%s%d" % (_col(2 + c), r), 0) for c in range(5)]
                break
        if ruthex is None:
            raise ValueError("Ruthex introuvable (id %d) dans la feuille Ruthex" % rid)
    return cfg, servo, bearing, ruthex


# ----------------------------------------------------------------------------
# Primitives géométriques (équivalents des primitives OpenSCAD)
# ----------------------------------------------------------------------------
def T(s, x=0.0, y=0.0, z=0.0):
    """translate([x,y,z])"""
    if s is None:
        return None
    s = s.copy()
    s.translate(V(x, y, z))
    return s


def R(s, rx=0.0, ry=0.0, rz=0.0):
    """rotate([rx,ry,rz]) : X puis Y puis Z, comme OpenSCAD."""
    if s is None:
        return None
    s = s.copy()
    o = V(0, 0, 0)
    if rx:
        s.rotate(o, V(1, 0, 0), rx)
    if ry:
        s.rotate(o, V(0, 1, 0), ry)
    if rz:
        s.rotate(o, V(0, 0, 1), rz)
    return s


def box(sx, sy, sz):
    """cube([sx,sy,sz], center=true) ; une dimension nulle donne « rien », comme OpenSCAD."""
    if min(sx, sy, sz) <= 1e-9:
        return None
    return Part.makeBox(sx, sy, sz, V(-sx / 2.0, -sy / 2.0, -sz / 2.0))


def cyl(r, h):
    """cylinder(r=r, h=h, center=true), axe Z"""
    return Part.makeCylinder(r, h, V(0, 0, -h / 2.0), V(0, 0, 1))


def cone(r1, r2, h):
    """cylinder(r1=r1, r2=r2, h=h, center=true), axe Z"""
    return Part.makeCone(r1, r2, h, V(0, 0, -h / 2.0), V(0, 0, 1))


def ecyl(rx, ry, h):
    """scale([rx,ry,1]) cylinder(r=1, h=h, center=true) : cylindre elliptique, axe Z"""
    if abs(rx - ry) < 1e-9:
        return cyl(rx, h)
    swap = ry > rx
    a, b = (ry, rx) if swap else (rx, ry)
    e = Part.Ellipse(V(0, 0, 0), a, b)
    f = Part.Face(Part.Wire([e.toShape()]))
    s = f.extrude(V(0, 0, h))
    s.translate(V(0, 0, -h / 2.0))
    if swap:
        s.rotate(V(0, 0, 0), V(0, 0, 1), 90)
    return s


def prism(pts, h):
    """linear_extrude(h) polygon(pts)"""
    p = [V(x, y, 0) for x, y in pts]
    w = Part.makePolygon(p + [p[0]])
    return Part.Face(w).extrude(V(0, 0, h))


def rbox(sx, sy, sz, r):
    """minkowski() { cube([sx,sy,sz], center=true); sphere(r); }
    = boîte de (sx+2r, sy+2r, sz+2r) dont toutes les arêtes sont arrondies au rayon r."""
    b = box(sx + 2 * r, sy + 2 * r, sz + 2 * r)
    if r > 1e-9:
        b = b.makeFillet(r, b.Edges)
    return b


def halfspace_below_z0():
    """translate([-500,-500,-1000]) cube([1000,1000,1000])"""
    return Part.makeBox(1000, 1000, 1000, V(-500, -500, -1000))


def _flat(items):
    out = []
    for i in items:
        if i is None:
            continue
        if isinstance(i, (list, tuple)):
            out += _flat(i)
        else:
            out.append(i)
    return out


def U(*items):
    """union()"""
    lst = _flat(items)
    if not lst:
        return None
    if len(lst) == 1:
        return lst[0]
    return lst[0].multiFuse(lst[1:])


def D(a, *tools):
    """difference() { a; tools... }"""
    if a is None:
        return None
    t = U(*tools)
    if t is None:
        return a
    return a.cut(t)


def I(a, b):
    """intersection()"""
    if a is None or b is None:
        return None
    return a.common(b)


def grow(s, d):
    """Approximation de minkowski() avec une petite sphère de rayon d (offset arrondi)."""
    try:
        g = s.makeOffsetShape(d, 1e-4)
        if g.isValid() and g.Volume > s.Volume:
            return g
    except Exception:
        pass
    return s


def frange(start, step, stop):
    """[start:step:stop] d'OpenSCAD (borne incluse à epsilon près)."""
    if step <= 0:
        return []
    n = int(math.floor((stop - start) / step + 1e-9))
    return [start + i * step for i in range(n + 1)]


def _msg(t):
    FreeCAD.Console.PrintMessage(t + "\n")


def _warn(t):
    FreeCAD.Console.PrintWarning("WARNING: " + t + "\n")


# ----------------------------------------------------------------------------
# Géométrie : traduction module par module de servo-frame.scad
# ----------------------------------------------------------------------------
def make_parts(cfg, servo, bearing, which=PART_NAMES, ruthex=None):
    """Construit les pièces demandées. Renvoie {nom: Part.Shape ou None}."""

    # --- configuration.scad -------------------------------------------------
    ear_support_screw = int(round(cfg["ear_support_screw"]))
    ear_support_screwhead = cfg["ear_support_screwhead"]
    z_axis_servo_cover = int(round(cfg["z_axis_servo_cover"]))
    arm_thickness = cfg["arm_thickness"]
    arm_screw_head_dia = cfg["arm_screw_head_dia"]
    frame_thickness = cfg["frame_thickness"]
    frame_extra_width = cfg["frame_extra_width"]
    frame_arm_clearance = cfg["frame_arm_clearance"]
    frame_mode_light = int(round(cfg["frame_mode_light"]))
    with_bearing = int(round(cfg["with_bearing"]))
    with_boxed = int(round(cfg["with_boxed"]))
    boxed_w = cfg["boxed_w"]
    boxed_l = cfg["boxed_l"]
    boxed_h = cfg["boxed_h"]
    boxed_thickness = cfg["boxed_thickness"]
    boxed_light = cfg["boxed_light"]
    minkowski_rounded = cfg["minkowski_rounded"]

    ruthex_id = int(round(cfg.get("ruthex_id", 0) or 0))
    ruthex_extra_depth = cfg.get("ruthex_extra_depth", 0) or 0

    # --- Processing (variables internes) ---------------------------------------
    legformat = int(servo[0])
    s_h = servo[1] + .3
    s_w = servo[2] + .3
    s_t = servo[3]
    s_h_ear = servo[4] + .1
    s_w_gear = servo[5]
    s_gear_h = servo[6]

    s_ear_t = (servo[7] + .1) if legformat else 0
    s_ear_w = (servo[8] + .2) if legformat else 3
    s_ear_h = (servo[9] if servo[9] else servo[8]) + .2
    s_ear_h_third = (servo[10] + .2) if servo[10] else s_ear_h

    s_ear_isnotch = 1 if servo[11] < 0 else 0
    s_ear_hole_dia = abs(servo[11])
    s_cable_h = servo[12]
    arm_screw_dia = servo[13]

    b_id = bearing[0]
    b_ed = bearing[1]
    b_t = bearing[2] + .4

    frame_gear_clearance = frame_arm_clearance + arm_thickness
    frame_body_clearance = frame_gear_clearance + s_gear_h

    if with_bearing and arm_screw_dia > b_id:
        raise ValueError("BEARING INTERNAL DIAMETER inferior to SCREW DIAMETER")

    # Checks
    _check_arm_diff = (s_h_ear - s_h / 2.0 - s_t) - (-s_h / 2.0 + s_cable_h + 4)
    _check_arm_fail = (legformat == 1 and ear_support_screw > 0
                       and _check_arm_diff < 0 and _check_arm_diff < s_ear_w / -2.0)
    if _check_arm_fail and "EarSupportScrew" in which:
        _msg("******************")
        _warn("Unable to produce 'ear_support_screw'>0 - not enough space between cable and ear")
        _warn("Falling back to ear_support_screw=0")
        _msg("******************")
    _ear_support_screw = 0 if (_check_arm_fail or legformat == 0) else ear_support_screw

    # ------------------------------------------------------------------ ears
    def servo_ear_solid(masky=0, issupport=0):
        parts = []
        if legformat <= 1:
            ear_y = s_h_ear - s_h / 2.0 + s_ear_t / 2.0
            sub = [box(s_w + s_ear_w * 2, s_ear_t, s_t + .1)]
            L = s_w + s_ear_w * 2 + frame_extra_width
            if issupport:
                u = U(cyl(s_t / 2.0, L), T(box(s_t / 2.0, s_t, L), s_t / 4.0, 0, 0))
                d = D(u, T(box(s_t, s_t / 2.0, s_w + s_ear_w * 2), 0, -s_t / 2.0, 0))
                d = T(d, 0, s_ear_t / 2.0, 0)
                if legformat and _ear_support_screw:
                    c = T(box(s_t / 2.0, s_t / 2.0 + s_ear_w, L),
                          s_t / 4.0, -s_t * 3 / 4.0 - s_ear_t / 2.0 + s_ear_w / 2.0, 0)
                else:
                    c = T(box(s_t, s_t / 2.0, L), 0, -s_t / 4.0 - s_ear_t / 2.0, 0)
                sub.append(R(U(d, c), 0, 90, 0))
            else:
                if legformat and _ear_support_screw:
                    sub.append(T(box(s_w + s_ear_w * 2, s_t / 2.0, s_t + .1), 0, -s_t / 4.0 - s_ear_t / 2.0, 0))
                    yy = -s_t * 3 / 4.0 - s_ear_t / 2.0
                    sub.append(T(cyl(0.8, 200), -s_w / 2.0 - s_ear_w / 2.0, yy, 0))
                    sub.append(T(cyl(0.8, 200), s_w / 2.0 + s_ear_w / 2.0, yy, 0))
                    if _ear_support_screw > 1:  # with servo ear screw
                        sub.append(T(cyl(ear_support_screwhead / 2.0, s_t * 2), -s_w / 2.0 - s_ear_w / 2.0, s_ear_t / 2.0, 0))
                        sub.append(T(cyl(ear_support_screwhead / 2.0, s_t * 2), s_w / 2.0 + s_ear_w / 2.0, s_ear_t / 2.0, 0))
            parts.append(T(U(sub), 0, ear_y, 0))

        # All except 3 vertical_ears
        if issupport and legformat <= 2:
            # bottom blocker
            wall = 2 if s_ear_w < 4 else s_ear_w / 2.0
            ell = ecyl(s_t, s_ear_w + frame_extra_width, s_w)
            if frame_mode_light:
                ell = D(ell, ecyl(s_t * .7, (s_ear_w + frame_extra_width) * .7, s_w + 2))
            ell = R(ell, 0, 90, 0)
            cuts = [T(box(1000, 1000, 1000), 0, 0, -500),
                    T(box(1000, 1000, 1000), 0, 500, 0)]
            nb = 3
            cell = (s_w - wall * (nb + 1)) / nb
            if cell > 0:
                for x in frange(-s_w / 2.0 + wall, cell + wall, s_w / 2.0):
                    cuts.append(T(box(cell, s_h, 1000), x + cell / 2.0, -s_h / 2.0 - wall, 0))
            blk = D(ell, cuts)
            extra = []
            if frame_mode_light:
                extra.append(T(box(s_w, wall, s_t * .8), 0, -wall / 2.0, s_t / 2.0))
            # no z-axis locking - adding a flat surface
            if _ear_support_screw == 0:
                extra.append(T(box(s_ear_w * 2, s_ear_w + frame_extra_width, s_t), 0, -s_ear_w / 2.0, s_t / 2.0))
            parts.append(T(U(blk, extra), 0, -s_h / 2.0, -s_t / 2.0))

        # All vertical_ears
        if legformat > 1:
            sp = 2  # surround_spacer
            ey = s_h_ear - s_h / 2.0 + s_ear_h / 2.0
            parts.append(T(box(s_w + s_ear_w * 2, s_ear_h, s_ear_t + masky), 0, ey, masky / 2.0))
            if issupport:
                parts.append(T(box(s_w + s_ear_w * 2 + sp, s_ear_h + sp, (s_t + s_ear_t) / 2.0),
                               0, ey, (s_ear_t - s_t) / 4.0))
            if legformat == 3:
                ty = -s_h / 2.0 - s_ear_w / 2.0
                parts.append(T(box(s_ear_h_third, s_ear_w * 2, s_ear_t + masky), 0, ty, masky / 2.0))
                if issupport:
                    parts.append(T(box(s_ear_h_third + sp, s_ear_w + sp, (s_t + s_ear_t) / 2.0),
                                   0, ty, (s_ear_t - s_t) / 4.0))
        return U(parts)

    def servo_cover_hole_mask():
        if _ear_support_screw == 0 and z_axis_servo_cover:
            return U(
                T(cyl(.8, 100), (s_w + s_ear_w + frame_extra_width / 2.0) / 2.0, s_ear_w, 0),
                T(cyl(.8, 100), -(s_w + s_ear_w + frame_extra_width / 2.0) / 2.0, s_ear_w, 0),
                T(cyl(.8, 100), 0, -(s_h + s_ear_w + frame_extra_width / 2.0) / 2.0, 0))
        return None

    def servo_cover():
        if _ear_support_screw == 0 and z_axis_servo_cover:
            xmax = (s_w + frame_extra_width) / 2.0 + s_ear_w
            ymax = (s_h + frame_extra_width) / 2.0 + s_ear_w + s_ear_w * 2
            plate = T(prism([(-xmax, -s_ear_w * 2), (-xmax, 0), (xmax, 0), (xmax, -s_ear_w * 2),
                             (s_ear_w, -ymax), (-s_ear_w, -ymax)], 1), 0, s_ear_w * 2, 0)
            d = D(plate, servo_cover_hole_mask())
            return T(d, 0, -s_h / 2.0 - frame_extra_width - s_ear_w * 3 - 10, -s_t / 2.0)
        return None

    # ------------------------------------------------------- trous Ruthex
    def ruthex_active(quiet=True):
        """Ruthex actif ? Pas d'insert (id 0), servo sans oreilles, ou format 1 avec bloc en L : non."""
        if not ruthex_id or ruthex is None:
            return False
        if legformat == 0:
            if not quiet:
                _warn("ruthex_id=%d ignoré : ce servo n'a pas d'oreilles (LEG_FORMAT 0)" % ruthex_id)
            return False
        if legformat == 1 and _ear_support_screw:
            if not quiet:
                _warn("ruthex_id=%d ignoré : en LEG_FORMAT 1, l'espace sous l'oreille est occupé par le "
                      "bloc en L (ear_support_screw>0). Mettez ear_support_screw=0 pour utiliser un Ruthex." % ruthex_id)
            return False
        return True

    def ruthex_pads():
        """Épaissit le cadre sous chaque oreille pour que l'insert (longueur L) tienne en entier.
        Matière disponible sous le siège de l'oreille :
          - LEG_FORMAT 2 et 3 : (s_t - s_ear_t)/2 vers -Z ; on ajoute un bloc sous le cadre si L est plus grand
          - LEG_FORMAT 1      : presque rien vers -Y ; on ajoute un bloc de longueur L sous l'oreille"""
        if not ruthex_active():
            return None
        Lins = ruthex[3] + ruthex_extra_depth        # profondeur de matière voulue
        m = ruthex[2] + 0.2 + 2.4                    # largeur mini autour du trou (paroi 1.2 mm)
        xlo = s_w / 2.0                              # côté corps du servo
        xhi = max(s_w / 2.0 + s_ear_w + frame_extra_width / 2.0, s_w / 2.0 + s_ear_w / 2.0 + m / 2.0)
        pads = []
        if legformat == 1:
            y_top = s_h_ear - s_h / 2.0              # siège de l'oreille (face vers -Y)
            for sx in (-1, 1):
                pads.append(T(box(xhi - xlo, Lins, s_t), sx * (xlo + xhi) / 2.0, y_top - Lins / 2.0, 0))
            _msg("Ruthex : bloc de %.2f mm sous chaque oreille (axe Y)" % Lins)
        else:
            avail = (s_t - s_ear_t) / 2.0            # matière actuelle sous le siège de l'oreille
            need = Lins - avail
            if need < 0.1:
                _msg("Ruthex : épaisseur suffisante (%.2f mm disponibles pour %.2f mm)" % (avail, Lins))
                return None
            z_top = -s_t / 2.0 + 0.5                 # recouvrement avec le cadre existant
            z_bot = -s_t / 2.0 - need
            hz = z_top - z_bot
            ey = s_h_ear - s_h / 2.0 + s_ear_h / 2.0
            sy = max(s_ear_h + 2, m)
            for sx in (-1, 1):
                pads.append(T(box(xhi - xlo, sy, hz), sx * (xlo + xhi) / 2.0, ey, (z_top + z_bot) / 2.0))
            if legformat == 3:                       # oreille arrière
                pads.append(T(box(max(s_ear_h_third + 2, m), max(s_ear_w + 2, m), hz),
                              0, -s_h / 2.0 - s_ear_w / 2.0, (z_top + z_bot) / 2.0))
            _msg("Ruthex : cadre épaissi de %.2f mm sous les oreilles (L=%.2f, disponible=%.2f)" % (need, Lins, avail))
        return U(pads)

    def ruthex_holes():
        """Trous traversants Ø (d3 + 0,2) au centre de chaque oreille, pour presser un insert Ruthex.
        L'axe suit celui de la vis d'oreille du servo :
          - LEG_FORMAT 1 (oreilles à plat dans le plan XZ) : axe Y
          - LEG_FORMAT 2 et 3 (oreilles minces en Z)        : axe Z
        et, en format 3, un trou supplémentaire dans l'oreille arrière."""
        if not ruthex_active(quiet=False):
            return None
        r = (ruthex[2] + 0.2) / 2.0   # d3 + 0.2 mm de jeu
        L = 100.0
        holes = []
        if legformat == 1:
            y_top = s_h_ear - s_h / 2.0                       # face inférieure de l'oreille
            y_hi = y_top + s_ear_t + s_t / 2.0 + 1            # au-dessus du support qui enserre l'oreille
            y_lo = y_top - L
            for sx in (-1, 1):
                x = sx * (s_w / 2.0 + s_ear_w / 2.0)
                holes.append(T(R(cyl(r, y_hi - y_lo), 90, 0, 0), x, (y_hi + y_lo) / 2.0, 0))
        else:
            z_hi = s_ear_t / 2.0 + 1
            zc = z_hi - L / 2.0
            ey = s_h_ear - s_h / 2.0 + s_ear_h / 2.0
            for sx in (-1, 1):
                holes.append(T(cyl(r, L), sx * (s_w / 2.0 + s_ear_w / 2.0), ey, zc))
            if legformat == 3:   # oreille arrière
                holes.append(T(cyl(r, L), 0, -s_h / 2.0 - s_ear_w / 2.0, zc))
        _msg("Ruthex %d : trous traversants Ø%.2f mm (d3 + 0.2), %d trou(s)" % (ruthex_id, 2 * r, len(holes)))
        return U(holes)

    # ---------------------------------------------------- ear support screw
    def servo_ear_support_screw_solid():
        if not (legformat == 1 and _ear_support_screw):
            return None
        pts = [(0, 0), (0, s_t * .4), (s_t / 2.0, s_t / 2.0), (s_t / 2.0, s_t),
               (s_t - 2, s_t), (s_t - 2, s_t / 2.0), (s_t, s_t / 2.0), (s_t, 0)]
        lblock = prism(pts, s_ear_w)
        cutters = [T(R(cyl(0.8, s_t), 0, 90, 0), s_t / 2.0, s_t * 3 / 4.0, s_ear_w / 2.0)]
        # if cable is too high ... cut the L-shaped part
        diff = (s_h_ear - s_h / 2.0 - s_t) - (-s_h / 2.0 + s_cable_h + 4)
        if diff < 0:
            cutters.append(T(box(6, 4, 1000), s_t / 2.0, s_t + diff + 2, 0))
        body = D(lblock, cutters)

        pin = None
        if _ear_support_screw != 2:
            dia = s_ear_hole_dia - .4  # with minkowski sphere
            c = cyl(dia / 2.0, (s_ear_t - .2) * 2)
            if not s_ear_isnotch:
                c = D(c, R(T(box(1000, 1000, 1000), 0, 0, 500 + (s_ear_t + dia) / 4.0), 55, 0, 0))
            # minkowski(A+B, sphere(0.2)) = minkowski(A) + minkowski(B) : on arrondit chaque
            # composant séparément (plus fiable qu'un offset sur l'union).
            pin = grow(R(c, 90, 0, 0), 0.2)
            if s_ear_isnotch:  # With central notch
                pin = U(pin, grow(T(box(dia, (s_ear_t - .2) * 2, s_ear_w / 2.0), 0, 0, -s_ear_w / 4.0), 0.2))
            pin = T(pin, s_t / 2.0, 0, s_ear_w / 2.0)
            pin = D(pin, T(box(1000, 1000, 1000), 0, 0, -500))
        both = U(body, pin)
        return T(both, -s_h, -s_t - s_h / 2.0 - s_ear_w - frame_extra_width - 10, -s_t / 2.0)

    def servo_ear_support_screw():
        a = servo_ear_support_screw_solid()
        if a is None:
            return None
        return U(a, a.mirror(V(0, 0, 0), V(1, 0, 0)))

    # --------------------------------------------------------------- bearing
    def servo_bearing_holder(issupport=0, locker=0):
        gx = s_w / 2.0 - s_w_gear
        parts = []
        if issupport == 0:
            if locker == 0:
                # Bearing surround
                hh = b_t * 2 + frame_extra_width + 0.1
                sur = R(U(cyl((b_ed - 1) / 2.0, hh), T(box(b_ed - 1, s_t / 2.0, hh), 0, s_t / 4.0, 0)), 90, 0, 0)
                parts.append(T(sur, gx, s_h / 2.0 + (b_t * 2) / 2.0 + frame_body_clearance + frame_extra_width / 2.0, 0))
                # Bearing screw head opening
                if arm_screw_dia == b_id:
                    o = R(T(cyl(arm_screw_head_dia / 2.0 + .5, b_t), 0, 0, -b_t), 90, 0, 0)
                    parts.append(T(o, gx, s_h / 2.0 + frame_body_clearance + b_t, 0))
                # Bearing (ovalized a bit to avoid any unnecessary vertical force on the shaft)
                br = U(ecyl(b_ed / 2.0, b_ed / 2.0 * 1.2, b_t), T(box(b_ed, s_t / 2.0, b_t), 0, s_t / 4.0, 0))
                br = R(T(br, 0, 0, -b_t), 90, 0, 0)
                parts.append(T(br, gx, s_h / 2.0 + frame_body_clearance, 0))
            # Bearing locker
            b_t_clearance = 0.2 if locker else 0
            lk = D(T(box(s_w, 3, b_t - b_t_clearance), 0, s_t / 2.0 - 1.5, 0),
                   ecyl(b_ed / 2.0, b_ed / 2.0 * 1.2, b_t + 1))
            lk = T(lk, 0, 0, -b_t + b_t_clearance / 2.0)
            parts.append(T(R(lk, 90, 0, 0), gx, s_h / 2.0 + frame_body_clearance, 0))
        if issupport:
            hs = D(ecyl(s_w_gear + s_ear_w + frame_extra_width, s_t, b_t * 2),
                   T(box(1000, 1000, 1000), 0, -500, 0))
            parts.append(T(R(hs, 90, 0, 0), gx, s_h / 2.0 + frame_body_clearance + b_t, -s_t / 2.0))
        return U(parts)

    def servo_bearing_holder_cut_mask():
        y = s_h / 2.0 + (b_t * 2) / 2.0 + frame_body_clearance
        return T(U(T(box(b_t, b_t * 1.5, s_t), 0, 0, s_t - 1.2),
                   T(box(b_t, b_t * 1.5, s_t), s_w - s_w_gear * 2, 0, s_t - 1.2)), 0, y, 0)

    def servo_bearing_holder_screw_mask():
        y = s_h / 2.0 + (b_t * 2) / 2.0 + frame_body_clearance
        return T(U(cyl(.8, s_t * 2), T(cyl(.8, s_t * 2), s_w - s_w_gear * 2, 0, 0)), 0, y, 0)

    def servo_bearing_holder_wscrew(issupport=0, locker=0):
        return D(servo_bearing_holder(issupport, locker),
                 servo_bearing_holder_cut_mask(),
                 servo_bearing_holder_screw_mask())

    def servo_gear_solid(issupport=0):
        parts = [T(R(cyl(2.75, s_gear_h), 90, 0, 0), s_w / 2.0 - s_w_gear, s_h / 2.0 + s_gear_h / 2.0, 0)]
        if with_bearing:
            if with_bearing != 2:
                parts.append(servo_bearing_holder_wscrew(issupport))
            if with_bearing != 1:
                parts.append(servo_bearing_holder_wscrew(issupport).mirror(V(0, 0, 0), V(1, 0, 0)))
        return U(parts)

    def servo_bearing_holder_fullscrew_mask():
        parts = []
        if with_bearing:
            if with_bearing != 2:
                parts.append(servo_bearing_holder_screw_mask())
            if with_bearing != 1:
                parts.append(servo_bearing_holder_screw_mask().mirror(V(0, 0, 0), V(1, 0, 0)))
        return U(parts)

    def servo_cable_solid(y=0):
        w = 4 if legformat < 2 else 6
        t = 6 if legformat < 2 else 4
        return T(box(s_w + (s_ear_w + frame_extra_width) * 2, w, t + y), 0, -s_h / 2.0 + w / 2.0 + s_cable_h, y / 2.0)

    # ---------------------------------------------------------- servo masks
    def servo_solid():
        return U(box(s_w, s_h, s_t + 2),  # Z: +2 for preview
                 servo_ear_solid(),
                 servo_gear_solid(),
                 servo_cable_solid())

    def servo_solid_mask():
        return U(servo_solid(),
                 servo_cable_solid(100),
                 servo_ear_solid(100) if legformat > 1 else None,
                 # Servo gear clearance
                 T(box(s_w, s_h + frame_body_clearance, s_t + 2), 0, frame_body_clearance / 2.0, 0),
                 servo_bearing_holder_fullscrew_mask())

    # ---------------------------------------------------------------- frame
    def frame_solid_light_mask():
        sz = (s_ear_w + frame_extra_width) / 3.0
        bdx = (s_w + s_ear_w + frame_extra_width) / 2.0
        bdy = (s_h + s_ear_w + frame_extra_width) / 2.0
        bdymax = bdy + frame_body_clearance
        ratiodensity = int(math.floor(bdx / sz))
        if ratiodensity < 1:
            return None
        cubes = []
        for x in frange(-bdx, (bdx * 2) / ratiodensity, bdx + 0.01):
            for y in frange(-bdy, (bdy + bdymax) / ratiodensity, bdymax + 0.01):
                cubes.append(T(box(sz, sz, 1000), x, y, 0))
        return U(cubes)

    def frame_solid():
        extra_width = frame_extra_width - minkowski_rounded
        arm_clearance = frame_body_clearance
        plate = T(rbox(s_w + (s_ear_w + extra_width) * 2,
                       s_h + (s_ear_w + extra_width) * 2 + arm_clearance,
                       frame_thickness + 100, minkowski_rounded),
                  0, arm_clearance / 2.0, -50 + frame_thickness - minkowski_rounded)
        parts = [plate]
        if with_boxed:
            r = minkowski_rounded
            outer = rbox(boxed_w - r, boxed_l - r, boxed_h + 100, r)
            inner = T(rbox(boxed_w - r - boxed_thickness * 2, boxed_l - r - boxed_thickness * 2, 200 - r, r),
                      0, 0, 100 - boxed_h / 2.0 + frame_thickness)
            tools = [inner]
            if boxed_light:
                yhalf = (boxed_w - boxed_thickness * 2 - r * 2) / 2.0
                for y in frange(-yhalf, boxed_light * 3, yhalf):
                    tools.append(T(box(1000, boxed_light, s_t), 0, y, -s_t / 2.0 + frame_thickness))
                xhalf = (boxed_l - boxed_thickness * 2 - r * 2) / 2.0
                for x in frange(-xhalf, boxed_light * 3, xhalf):
                    tools.append(T(box(boxed_light, 1000, s_t), x, 0, -s_t / 2.0 + frame_thickness))
            tools.append(Part.makeBox(1000, 1000, 1000, V(-500, -500, boxed_h / 2.0)))
            parts.append(T(D(outer, tools), 0, arm_clearance / 2.0, boxed_h / 2.0))
        body = U(parts)
        tools = [halfspace_below_z0()]
        if frame_mode_light:
            tools.append(frame_solid_light_mask())
        return D(body, tools)

    def frame_w_ear_solid():
        return U(T(frame_solid(), 0, 0, -s_t / 2.0),  # regulate y to servo side
                 servo_ear_solid(0, 1),
                 servo_gear_solid(1),
                 ruthex_pads())

    def servo_back_support_special():
        if legformat < 3 and s_ear_h_third:
            # Special added notch to block servo with external motor
            notch_w = s_w - s_t * 2 - 5
            if notch_w > 1:
                return T(box(notch_w, s_ear_h_third, s_t), 0, s_ear_h_third / 2.0 - s_h / 2.0, 0)
        return None

    def servo_frame():
        fr = D(frame_w_ear_solid(), servo_solid_mask(), servo_cover_hole_mask(), ruthex_holes())
        return U(fr, servo_back_support_special())

    # ------------------------------------------------- bearing shaft & lock
    def bearing_shaft_solid():
        if not with_bearing:
            return None
        cyl_visible = frame_arm_clearance + b_t / 2.0
        cyl_visible_dia = b_id + 1
        cyl_bearing = (0 if (arm_screw_head_dia == b_id or arm_screw_dia == b_id) else b_t + 1)
        screw_bearing = b_t if arm_screw_dia == b_id else 0
        cyl_bearing_dia = b_id - 0.1

        parts = [T(cone(arm_screw_dia, cyl_visible_dia / 2.0, cyl_visible), 0, 0, cyl_visible / 2.0)]
        if cyl_bearing:
            sub = U(cyl(cyl_bearing_dia / 2.0, cyl_bearing / 2.0),
                    T(cone(cyl_bearing_dia / 2.0, (cyl_bearing_dia - .4) / 2.0, cyl_bearing / 2.0), 0, 0, cyl_bearing / 2.0))
            parts.append(T(sub, 0, 0, cyl_visible + cyl_bearing / 4.0))
        shaft = D(U(parts), cyl(arm_screw_dia / 2.0 + 0.1, 1000))
        shaft = T(shaft, -s_w / 2.0, s_t + s_h / 2.0 + frame_body_clearance + frame_extra_width + 10, -s_t / 2.0)

        _msg("******************")
        _msg("Bearing shaft/arm screw:")
        if cyl_bearing:
            _msg("**** the shaft inserted in the bearing is printed")
        elif arm_screw_head_dia == b_id:
            _msg("**** 'arm_screw_head_dia' matches bearing internal diameter:")
            _msg("**** >> the screw head is the bearing shaft")
        else:
            _msg("**** 'arm_screw_dia' matches bearing internal diameter:")
            _msg("**** >> the screw is the bearing shaft")
        base = arm_thickness + cyl_visible + cyl_bearing + screw_bearing
        _msg("**** screw length (threaded part) should be approximately between %g and %g mm"
             % (base + 2, base + s_gear_h + 1))
        _msg("**** >> Tuning the length is possible with the 'frame_arm_clearance' parameter")
        _msg("**** screw thread metric is M%g" % arm_screw_dia)
        if not cyl_bearing and not screw_bearing:
            _msg("**** screw head is a cylinder with a %g mm diameter" % arm_screw_head_dia)
        _msg("******************")
        return shaft

    def bearing_lock_solid():
        if not with_bearing:
            return None
        x = I(servo_bearing_holder_wscrew(1), servo_bearing_holder(0, 1))
        if x is None or not x.Solids:
            return None
        x = T(x, -frame_body_clearance, -b_t / 2.0 - frame_body_clearance - s_h / 2.0, -s_t / 2.0)
        x = R(x, 90, 0, 0)
        return T(x, s_w / 2.0, s_t + s_h / 2.0 + frame_body_clearance + frame_extra_width + 10, -s_t / 2.0)

    # --------------------------------------------------------------- assemble
    builders = {
        "ServoFrame": servo_frame,
        "EarSupportScrew": servo_ear_support_screw,
        "ServoCover": servo_cover,
        "BearingShaft": bearing_shaft_solid,
        "BearingLock": bearing_lock_solid,
    }
    out = {}
    for name in which:
        shp = builders[name]()
        if shp is not None:
            try:
                shp = shp.removeSplitter()
            except Exception:
                pass
        out[name] = shp
    return out


# ----------------------------------------------------------------------------
# Objets FreeCAD liés aux feuilles (recalcul automatique)
# ----------------------------------------------------------------------------
def _wrap_shape(shp):
    """Évite que la Placement de la forme devienne celle de l'objet."""
    if shp is None:
        return Part.Shape()
    if not shp.Placement.isIdentity():
        return Part.makeCompound([shp])
    return shp


class ServoPartProxy:
    """Part::FeaturePython : une pièce, recalculée quand une feuille change."""

    def __init__(self, obj, part, sheets):
        if "PartName" not in obj.PropertiesList:
            obj.addProperty("App::PropertyString", "PartName", "ServoFrame", "Pièce générée")
            obj.addProperty("App::PropertyLinkList", "Sheets", "ServoFrame",
                            "Feuilles Config, Servos, Bearings, Ruthex")
        obj.PartName = part
        obj.Sheets = sheets
        obj.setEditorMode("PartName", 1)
        obj.Proxy = self

    def execute(self, obj):
        by_name = {s.Name: s for s in obj.Sheets}
        cfg, servo, bearing, ruthex = read_inputs(by_name["Config"], by_name["Servos"],
                                                  by_name["Bearings"], by_name.get("Ruthex"))
        shapes = make_parts(cfg, servo, bearing, (obj.PartName,), ruthex)
        obj.Shape = _wrap_shape(shapes[obj.PartName])

    def __getstate__(self):
        return None

    def __setstate__(self, state):
        return None


def build(doc=None):
    """Crée (ou met à jour) le document : 3 feuilles + 5 pièces."""
    if doc is None:
        doc = FreeCAD.ActiveDocument or FreeCAD.newDocument("WingServoFrame")

    cfg = doc.getObject("Config") or create_config_sheet(doc)
    servos = doc.getObject("Servos") or create_servos_sheet(doc)
    bearings = doc.getObject("Bearings") or create_bearings_sheet(doc)
    ruthex = doc.getObject("Ruthex") or create_ruthex_sheet(doc)
    doc.recompute()  # évalue les feuilles avant les pièces

    sheets = [cfg, servos, bearings, ruthex]
    for name in PART_NAMES:
        obj = doc.getObject(name)
        if obj is None:
            obj = doc.addObject("Part::FeaturePython", name)
            ServoPartProxy(obj, name, sheets)
            if FreeCAD.GuiUp:
                obj.ViewObject.Proxy = 0
        elif not isinstance(getattr(obj, "Proxy", None), ServoPartProxy):
            ServoPartProxy(obj, name, sheets)  # macro relancée sur un document rouvert
        else:
            obj.Sheets = sheets
        obj.touch()
    doc.recompute()

    if FreeCAD.GuiUp:
        try:
            import FreeCADGui
            FreeCADGui.SendMsgToActiveView("ViewFit")
            FreeCADGui.ActiveDocument.ActiveView.viewIsometric()
        except Exception:
            pass
    return doc


def export_stl(folder, doc=None):
    """Exporte chaque pièce en STL. Le maillage utilise fn_segments ($fn) de la feuille Config."""
    import os
    import MeshPart
    doc = doc or FreeCAD.ActiveDocument
    fn = int(sget(doc.getObject("Config"), "fn_segments", 100))
    ang = math.radians(360.0 / max(fn, 8))
    for name in PART_NAMES:
        obj = doc.getObject(name)
        if obj is None or obj.Shape.isNull() or not obj.Shape.Solids:
            continue
        mesh = MeshPart.meshFromShape(Shape=obj.Shape, LinearDeflection=0.02,
                                      AngularDeflection=ang, Relative=False)
        path = os.path.join(folder, name + ".stl")
        mesh.write(path)
        _msg("STL : " + path)


build()

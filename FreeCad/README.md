# Wing Servo Frame pour FreeCAD

🇫🇷 Français · [🇬🇧 English](README.en.md)

Macro FreeCAD qui génère un **cadre de servo** (« servo frame ») pour aile, avec support de roulement sur l'axe du palonnier, oreilles de maintien, couvercle, boîtier optionnel et logement pour inserts filetés **Ruthex**.

Tous les réglages se font dans une feuille de calcul FreeCAD : vous modifiez une valeur, vous recalculez, les pièces se régénèrent.

C'est une conversion en Python/FreeCAD du projet OpenSCAD `servo-frame.scad` de Guillaume F. (licence GPL). Les paramètres de son `configuration.scad` sont repris dans la feuille `Config`.

## Sommaire

1. [Installation](#1-installation)
2. [Utilisation](#2-utilisation)
3. [Les pièces produites](#3-les-pièces-produites)
4. [Paramètres de la feuille Config](#4-paramètres-de-la-feuille-config)
5. [Les bases de données : Servos, Bearings, Ruthex](#5-les-bases-de-données--servos-bearings-ruthex)
6. [Inserts Ruthex](#6-inserts-ruthex)
7. [Export STL](#7-export-stl)
8. [Dépannage](#8-dépannage)
9. [Compatibilité et crédits](#9-compatibilité-et-crédits)

---

## 1. Installation

1. Installez [FreeCAD](https://www.freecad.org/downloads.php).
2. Téléchargez le fichier **`servo_frame_freecad.py`** de ce dépôt (bouton *Download raw file*, ou clonez le dépôt).
3. Copiez-le dans votre **dossier de macros FreeCAD**. Pour le connaître : *Édition → Préférences → Général → Macro*, champ « Dossier de macros ». Emplacements habituels :

   | Système | Dossier |
   |---|---|
   | Windows | `%APPDATA%\FreeCAD\Macro\` |
   | Linux | `~/.local/share/FreeCAD/Macro/` |
   | macOS | `~/Library/Application Support/FreeCAD/Macro/` |

4. Dans FreeCAD, ouvrez *Macro → Macros…* : `servo_frame_freecad` apparaît dans la liste.

**Sans installer :** ouvrez simplement le fichier `.py` dans FreeCAD (*Fichier → Ouvrir*), puis lancez *Macro → Exécuter la macro* (Ctrl+F6).

## 2. Utilisation

### Première génération

1. Lancez FreeCAD et créez un document vide (ou ne créez rien : la macro en crée un nommé `WingServoFrame`).
2. *Macro → Macros…*, sélectionnez `servo_frame_freecad`, cliquez sur **Exécuter**.
3. La macro crée dans le document :
   - **4 feuilles de calcul** : `Config` (vos réglages), `Servos`, `Bearings` et `Ruthex` (les bases de données) ;
   - **5 pièces** (voir [section 3](#3-les-pièces-produites)), déjà disposées côte à côte, prêtes à imprimer.

Avec les valeurs par défaut, le servo est un KingMax CLS0911W avec un roulement 682XZZ à droite.

### Modifier la configuration

1. Ouvrez la feuille `Config` (double-clic dans l'arbre).
2. Modifiez les valeurs de la **colonne B** (cellules jaunes). La colonne C décrit chaque paramètre.
3. Recalculez le document : **Ctrl+R** (bouton *Recalculer*). Les pièces se régénèrent.

### Messages dans la vue rapport

Ouvrez *Affichage → Panneaux → Vue rapport* pour lire :
- la **longueur de vis** conseillée pour le palonnier quand un roulement est utilisé (réglable avec `frame_arm_clearance`) ;
- les avertissements (repli automatique de `ear_support_screw`, Ruthex ignoré…).

### Enregistrer et rouvrir

Enregistrez le document normalement (`.FCStd`). À la réouverture, les formes sont conservées mais **le recalcul automatique n'est plus actif** : relancez la macro (elle reconnecte les pièces au document existant, sans rien écraser), puis modifiez `Config` comme avant.

## 3. Les pièces produites

| Objet | Contenu | Présent quand |
|---|---|---|
| `ServoFrame` | Le cadre principal avec ses oreilles et ses supports de roulement | toujours |
| `EarSupportScrew` | Les deux blocs en L qui verrouillent les oreilles du servo | servo `LEG_FORMAT` 1 et `ear_support_screw` > 0 |
| `ServoCover` | Couvercle du servo | `ear_support_screw` = 0 et `z_axis_servo_cover` = 1 |
| `BearingShaft` | Axe qui s'insère dans le roulement (ou entretoise) | `with_bearing` > 0 |
| `BearingLock` | Verrou du roulement | `with_bearing` > 0 |

Une pièce non applicable reste vide : ce n'est pas une erreur.

## 4. Paramètres de la feuille Config

### Servo et roulement

| Paramètre | Défaut | Description |
|---|---|---|
| `servo_brand` | 5 | Marque du servo : colonne A de la feuille `Servos`. |
| `servo_index` | 0 | Numéro du servo dans la marque : colonne B de la feuille `Servos`. Par défaut : marque 5, servo 0 = KingMax CLS0911W. |
| `bearing_id` | 1 | Roulement à utiliser : colonne A de la feuille `Bearings`. Le diamètre de vis du palonnier du servo (colonne M de `Servos`) ne doit pas dépasser le diamètre intérieur du roulement. |

### Oreilles (ears)

| Paramètre | Défaut | Description |
|---|---|---|
| `ear_support_screw` | 1 | Pour les servos `LEG_FORMAT` 1 (oreilles horizontales) : gère les blocs en L vissés verticalement sur le cadre. **0** : aucun blocage en Z (montage classique avec sangle sous la peau de l'aile) ; **1** : avec une encoche centrale dans l'oreille ; **2** : avec des vis dans l'oreille ; **3** : 1 et 2 ensemble. Si l'espace entre le câble et l'oreille est insuffisant, la macro retombe sur 0 et le signale. |
| `ear_support_screwhead` | 3 | Si `ear_support_screw` = 2 : diamètre de la tête de vis (mm). |
| `z_axis_servo_cover` | 1 | Si `ear_support_screw` = 0 : fabrique un couvercle de servo (0 = non, 1 = oui). |
| `ruthex_id` | 0 | Insert Ruthex à presser dans les oreilles : id de la feuille `Ruthex`. **0 = pas d'insert.** Voir [section 6](#6-inserts-ruthex). |
| `ruthex_extra_depth` | 0 | Matière supplémentaire sous l'insert, en plus de sa longueur L (mm). |

### Palonnier (servo arm)

| Paramètre | Défaut | Description |
|---|---|---|
| `arm_thickness` | 0.5 | Épaisseur ajoutée du palonnier entre la tête de vis (haut de la partie filetée) et l'engrenage du servo (mm). Palonnier plastique : souvent 0,5 à 1 mm. Palonnier aluminium : souvent 1 à 2,5 mm. En cas de doute, prenez 0,5 mm : vous pourrez toujours poncer le cône s'il est trop grand. |
| `arm_screw_head_dia` | 4.4 | Diamètre de la tête de vis du palonnier (utile avec un roulement). Si elle est **égale au diamètre intérieur du roulement**, la tête de vis travaille directement dans le roulement et la pièce imprimée n'est qu'une entretoise (vis plus courte). Si elle est **différente**, la tête bloque l'axe imprimé par l'extérieur, et l'axe entre dans le roulement (vis plus longue). |

### Cadre (frame)

| Paramètre | Défaut | Description |
|---|---|---|
| `frame_thickness` | 1.5 | Épaisseur du cadre (mm). |
| `frame_extra_width` | 1.5 | Largeur supplémentaire du cadre autour du servo (mm). |
| `frame_arm_clearance` | 5.0 | Dégagement entre le haut du palonnier (trou de la vis) et le début du haut du cadre (support de roulement si `with_bearing`). Avec un roulement, ce paramètre fixe la longueur de la vis du palonnier, affichée dans la vue rapport. |
| `frame_mode_light` | 1 | **0** : cadre plein. **1** : cadre ajouré, plus léger et qui améliore probablement le collage. |

### Roulement (bearing)

| Paramètre | Défaut | Description |
|---|---|---|
| `with_bearing` | 1 | **0** : sans roulement. **1** : roulement à droite. **2** : roulement à gauche. **3** : des deux côtés (universel). |

### Boîtier (boxed)

| Paramètre | Défaut | Description |
|---|---|---|
| `with_boxed` | 0 | 0 = sans boîtier, 1 = avec boîtier autour du servo. |
| `boxed_w` | 50 | Largeur du boîtier (mm). |
| `boxed_l` | 50 | Longueur du boîtier (mm). |
| `boxed_h` | 18 | Hauteur du boîtier (mm). |
| `boxed_thickness` | 0.8 | Épaisseur des parois du boîtier (mm). |
| `boxed_light` | 2 | **0** : parois pleines. **> 0** : encoches verticales dans le boîtier, qui allègent et limitent les tensions à l'impression ; la valeur est la largeur de l'encoche (mm). |

### Divers (misc)

| Paramètre | Défaut | Description |
|---|---|---|
| `minkowski_rounded` | 1.5 | Rayon d'arrondi des angles du cadre (mm). |
| `fn_segments` | 150 | Équivalent de `$fn` d'OpenSCAD. FreeCAD travaille avec des cercles exacts : ce paramètre ne sert qu'à la **finesse du maillage à l'export STL** (30 suffit pour visualiser, 100 ou plus pour imprimer). |

## 5. Les bases de données : Servos, Bearings, Ruthex

Ces feuilles sont **lues par la macro** : modifier ou ajouter une ligne suffit.

### Feuille `Servos`

Une ligne par servo : `Marque`, `Index`, `Nom`, puis 14 colonnes de dimensions (mm). La macro cherche la ligne dont `Marque` et `Index` correspondent à `servo_brand` et `servo_index`. Elle compte **35 servos** (MKS, BlueBird, KST, Emax, TowerPro, KingMax, GDW).

| Colonne | Signification |
|---|---|
| `LEG_FORMAT` | Type d'oreilles : **0** sans oreilles, **1** oreilles horizontales, **2** oreilles verticales, **3** trois oreilles verticales |
| `A` | Hauteur du corps (bas du servo à la base de l'engrenage) |
| `B` | Largeur du corps (sans les oreilles) |
| `C` | Épaisseur du corps |
| `D` | Position des oreilles (bas du servo à la face basse de l'oreille) |
| `E` | Centre de l'engrenage au côté du corps (le plus petit) |
| `F` | Hauteur de l'engrenage |
| `G` | Épaisseur des oreilles |
| `H` | Largeur des oreilles |
| `I` | Hauteur des oreilles (oreilles verticales ; 0 = largeur d'oreille) |
| `J` | Avec trois oreilles : largeur de l'oreille arrière. Sinon : hauteur de l'encoche arrière pour un servo à moteur externe |
| `K` | Trou d'oreille : valeur **négative** = encoche, **positive** = trou (diamètre) |
| `L` | Position du câble (bas du servo à la base du câble) |
| `M` | Diamètre de la vis de l'engrenage (obligatoire si `with_bearing`) |

**Ajouter un servo :** ajoutez une ligne à la fin du tableau, sans ligne vide entre les servos (la lecture s'arrête à la première cellule vide de la colonne A), avec une marque et un index qui n'existent pas déjà. Mesurez le servo au pied à coulisse.

### Feuille `Bearings`

Colonnes : `Id`, `Nom`, `d` (diamètre intérieur), `D` (diamètre extérieur), `B` (épaisseur). 8 roulements, de MR52ZZ à MR95ZZ. `bearing_id` désigne l'`Id`.

### Feuille `Ruthex`

Colonnes : `Id`, `Nom`, `d1`, `d2`, `d3`, `L`, `W`. 19 inserts, plus l'id 0 réservé à « pas d'insert ». Voir la section suivante.

## 6. Inserts Ruthex

Avec `ruthex_id` différent de 0, la macro :

1. **perce des trous traversants** de diamètre **d3 + 0,2 mm** (0,2 mm de jeu fonctionnel) au centre de chaque oreille ;
2. **épaissit le cadre sous les oreilles** pour que la matière sous l'insert soit au moins égale à sa longueur **L** (+ `ruthex_extra_depth`).

Où les trous sont percés :

| `LEG_FORMAT` | Trous | Axe |
|---|---|---|
| 1 (oreilles horizontales) | 2 (une par oreille) | Y — **uniquement si `ear_support_screw` = 0** |
| 2 (oreilles verticales) | 2 (une par oreille) | Z |
| 3 (trois oreilles) | 3 (deux latérales + l'oreille arrière) | Z |
| 0 (sans oreilles) | aucun | un avertissement est affiché |

En `LEG_FORMAT` 1 avec `ear_support_screw` > 0, l'espace sous l'oreille est occupé par le bloc en L : le Ruthex est alors ignoré, avec un avertissement dans la vue rapport.

**Fond du cadre :** dès que L dépasse environ 4 mm, le cadre descend sous le plan d'origine, sous les oreilles. Le fond n'est plus plat à cet endroit : tenez-en compte pour l'orientation d'impression.

| Id | Nom | d3 (mm) | L (mm) |
|---|---|---|---|
| 0 | Aucun (pas d'insert) | — | — |
| 1 | M2 / #2-56 | 3,2 | 4,0 |
| 2 | #4-40 Short | 4,0 | 3,56 |
| 3 | M2,5 | 4,0 | 5,7 |
| 4 | M3 Short | 4,0 | 4,0 |
| 5 | M3x5x4 Voron | 4,4 | 4,0 |
| 6 | M3 / #4-40 | 4,0 | 5,7 |
| 7 | #6-32 Short | 4,8 | 3,8 |
| 8 | #6-32 | 4,8 | 7,1 |
| 9 | M4 Short | 5,6 | 4,0 |
| 10 | #8-32 Short | 5,6 | 4,7 |
| 11 | M4 / #8-32 | 5,6 | 8,1 |
| 12 | M5 Short | 6,4 | 5,8 |
| 13 | M5 / #10-24 / #10-32 UNF | 6,4 | 9,5 |
| 14 | 1/4in-20 Short | 8,0 | 6,4 |
| 15 | M6 / 1/4in-20 | 8,0 | 12,7 |
| 16 | M6 Short | 8,0 | 6,8 |
| 17 | M8 / 5/16in-18 | 9,6 | 12,7 |
| 18 | 3/8in-16 | 11,9 | 12,7 |
| 19 | M10 | 12,0 | 12,7 |

Les dimensions complètes (d1, d2, d3, L, W) sont dans la feuille `Ruthex`, d'après le tableau du fabricant.

## 7. Export STL

**Par l'interface :** sélectionnez les pièces à exporter dans l'arbre, puis *Fichier → Exporter…* et choisissez le format STL.

**Par la console Python** (maillage réglé par `fn_segments`) :

```python
exec(open("/chemin/vers/servo_frame_freecad.py", encoding="utf-8").read())
export_stl("/chemin/vers/un/dossier")
```

Un fichier `.stl` est créé par pièce non vide.

## 8. Dépannage

| Message ou symptôme | Cause et solution |
|---|---|
| `Servo introuvable (marque X, index Y)` | Aucune ligne de la feuille `Servos` ne correspond à `servo_brand` / `servo_index`. |
| `Roulement introuvable` / `Ruthex introuvable` | `bearing_id` ou `ruthex_id` absent de la feuille correspondante. |
| `BEARING INTERNAL DIAMETER inferior to SCREW DIAMETER` | La vis du servo (colonne M) est plus grosse que le roulement choisi : prenez un roulement de diamètre intérieur ≥ ce diamètre, ou mettez `with_bearing` à 0. |
| Pièces en rouge ou « Touched » après modification | Faites **Ctrl+R**. Si l'erreur persiste, lisez la vue rapport. |
| Une pièce est vide | Normal si elle ne s'applique pas (voir [section 3](#3-les-pièces-produites)). |
| Pas de recalcul après réouverture du document | Relancez la macro. |
| La ligne `ruthex_id` manque dans `Config` d'un ancien document | Supprimez la feuille `Config` et relancez la macro, ou ajoutez la ligne à la main avec l'alias `ruthex_id`. |

## 9. Compatibilité et crédits

- Développée et testée avec **FreeCAD 26.3**. Les autres versions n'ont pas été testées.
- Vérifiée par comparaison avec OpenSCAD sur 9 configurations (tous les formats d'oreilles, avec et sans roulement, couvercle, boîtier) : mêmes dimensions, volumes à environ 0,2 % près.
- Projet d'origine : **Wing Servo Frame**, Guillaume F., licence GPL.
- Licence de cette macro : **GPL**, comme le projet d'origine.

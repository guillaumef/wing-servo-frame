
help:
	@echo "  - stls"
	@echo "  - list"
	@echo "  - syncdoc"

.PHONY: stls

list:
	@for tg in `grep 'Servo #' servo-frame.scad | sed -e 's/.*#//' | sed -e 's/ *- */ /' | sed -e 's/[*].*//' | sed -e 's/  */ /' | sed -e 's/ *$$//' | sed -e 's/ /,/g'`; do \
		SERV_BRAND=`echo "$$tg" | cut -f 1 -d ','`;					\
		SERV_SERVO=`echo "$$tg" | cut -f 2 -d ','`;					\
		SERV_NAME=`echo "$$tg" | sed -e 's/^[0-9]*,[0-9]*,//' | sed -e 's/,/ /g'`;	\
		echo "# $$SERV_BRAND,$$SERV_SERVO	: $$SERV_NAME";\
	done;

syncdoc:
	@sed -e '/^Servo list:/,$$d' README.md > README.md.tmp
	@/bin/echo -e "Servo list:\n" >> README.md.tmp
	@for tg in `grep 'Servo #' servo-frame.scad | sed -e 's/.*#//' | sed -e 's/ *- */ /' | sed -e 's/[*].*//' | sed -e 's/  */ /' | sed -e 's/ *$$//' | sed -e 's/ /,/g'`; do \
		SERV_BRAND=`echo "$$tg" | cut -f 1 -d ','`;					\
		SERV_SERVO=`echo "$$tg" | cut -f 2 -d ','`;					\
		SERV_NAME=`echo "$$tg" | sed -e 's/^[0-9]*,[0-9]*,//' | sed -e 's/,/ /g'`;	\
		echo "- $$SERV_NAME" >> README.md.tmp;\
	 done;
	@mv README.md.tmp README.md

### Gen configurations and parallelize openscad ... CPU burn
stls: syncdoc stlconfs
	@make -j5 stlfiles

stlconfs:
	@for tg in `grep 'Servo #' servo-frame.scad | sed -e 's/.*#//' | sed -e 's/ *- */ /' | sed -e 's/[\/|(*].*//' | sed -e 's/  */ /' | sed -e 's/ *$$//' | sed -e 's/ /,/g'`; do \
		SERV_BRAND=`echo "$$tg" | cut -f 1 -d ','`;					\
		SERV_SERVO=`echo "$$tg" | cut -f 2 -d ','`;					\
		SERV_NAME=`echo "$$tg" | sed -e 's/^[0-9]*,[0-9]*,//' | sed -e 's/,/-/g'`;	\
		echo "$$SERV_BRAND + $$SERV_SERVO => $$SERV_NAME";	\
		DIR_TG="stls/$$SERV_NAME";				\
		mkdir -p $$DIR_TG;					\
		\
		echo "Get bearing info";					\
		openscad -D _servo_id_brand=$$SERV_BRAND 			\
			-D _servo_id_servo=$$SERV_SERVO				\
			-D _proc=1						\
			-o bearing.echo						\
			servo-frame.scad > /dev/null 2>&1;			\
		\
		BEARING_ID=`head -1 bearing.echo | sed -e 's/.*bearing://' | sed -e 's/ .*//'`;	\
		BEARING_FMT=`head -1 bearing.echo | sed -e 's/.*format://' | sed -e 's/".*//'`;	\
		rm -f bearing.echo;						\
		\
		echo "Processing with bearing #$$BEARING_ID : $$BEARING_FMT";	\
		\
		for with_bearing in 0 1 2 3; do					\
		  for frame_light in 0 1; do					\
		    if [ "$$frame_light" -eq 1 ]; then				\
		      NAME="hollow";						\
		    else							\
		      NAME="solid";						\
		    fi;								\
		    if [ "$$with_bearing" -eq 0 ]; then				\
		      NAME=$$NAME"_nobearing";					\
		    elif [ "$$with_bearing" -eq 1 ]; then			\
		      NAME=$$NAME"_bearingRight_"$$BEARING_FMT;			\
		    elif [ "$$with_bearing" -eq 2 ]; then			\
		      NAME=$$NAME"_bearingLeft_"$$BEARING_FMT;			\
		    elif [ "$$with_bearing" -eq 3 ]; then			\
		      NAME=$$NAME"_bearingLR_"$$BEARING_FMT;			\
		    fi;								\
		    \
		    CONF="$$DIR_TG/$$NAME.configuration.scad";			\
		    cat configuration.scad			 		\
		    | sed -E "s/^(frame_mode_light\s*=) *.*;/\1 "$$frame_light";/"		\
		    | sed -E "s/^(with_bearing\s*=) *.*;/\1 "$$with_bearing";/"			\
		    | sed -E "s/^(servo_id\s*=) *.*;/\1 [ "$$SERV_BRAND", $$SERV_SERVO ];/" 	\
		    | sed -E "s/^(bearing_id\s*=) *.*;/\1 $$BEARING_ID;/" 	\
		    > $$CONF.tmp;						\
		    if [ ! -f "$$CONF" ]; then					\
		      mv $$CONF.tmp $$CONF;					\
		    else							\
		      md51=`md5sum "$$CONF.tmp" | cut -d' ' -f1`;		\
		      md52=`md5sum "$$CONF" | cut -d' ' -f1`;			\
		      if [ "$$md51" != "$$md52" ]; then				\
		        mv $$CONF.tmp $$CONF;					\
		      else rm -f $$CONF.tmp;					\
		      fi;							\
		    fi;								\
		 done;								\
		done;								\
	 done;

CONFS = $(wildcard stls/*/*.configuration.scad)
STLS = $(patsubst %.configuration.scad, %.stl, $(CONFS))
GIFS = $(patsubst %.configuration.scad, %.gif, $(CONFS))

stlfiles: $(STLS) $(GIFS) GIFSHOW.md


%.stl: %.configuration.scad servo-frame.scad
	@SRC=`echo "$@" | sed -e 's/stl$$/scad/'`; 				\
	 ECHO=`echo "$@" | sed -e 's/stl$$/echo/'`;				\
	 BASENAME=`basename "$<"`;						\
	 sed -E "s/<configuration.scad>/<$$BASENAME>/" servo-frame.scad	> "$$SRC";	\
	 openscad -o "$$ECHO" "$$SRC";						\
	 echo "openscad -o \"$@\" \"$$SRC\""; 					\
	 openscad -o "$@" "$$SRC";						\
	 rm -f "$$SRC"

%.gif: %.stl
	@SRC=`echo "$<" | sed -e 's/stl$$/png.scad/'`;				\
	 echo "$@";								\
	 BASENAME=`basename "$<"`;						\
	 echo "rotate([0,0,t])import(\"$$BASENAME\");" > $$SRC;			\
	 i=0; while [ $$i -lt 360 ]; do						\
	   IDX="$$i"; 								\
	   if [ "$$IDX" -lt 10 ]; then IDX="00$$IDX";				\
	   elif [ "$$IDX" -lt 100 ]; then IDX="0$$IDX"; fi;			\
	   openscad -o $@.$$IDX.png -D t=$$i --camera 0,0,0,55,0,0,250 		\
	    --imgsize=800,600 $$SRC > /dev/null 2>&1;				\
	   i=$$(($$i+10));							\
	 done;									\
	 convert '$@.*.png' -set delay 1x5 $@;					\
	 rm -f $$SRC $@.*.png

GIFSHOW.md: $(GIFS)
	@rm -f list.tmp GIFSHOW.md; 		\
	 for file in $(GIFS); do 		\
	   echo $$file >> list.tmp;		\
	 done;					\
	 NP="";					\
	 for file in `sort list.tmp`; do	\
	   N=`echo $$file | cut -d/ -f2`;	\
	   if [ "$$NP" != "$$N" ]; then		\
	     echo "" >> GIFSHOW.md;		\
	     echo "## $$N" >> GIFSHOW.md;	\
	     NP="$$N";				\
	     TP="";				\
	   fi;					\
	   T=`echo $$file | sed -e 's/.*\/\(hollow\|solid\).*/\1/'`; \
	   if [ "$$TP" != "$$T" ]; then		\
	     echo "" >> GIFSHOW.md;		\
	     echo "#### $$T" >> GIFSHOW.md;	\
	     TP="$$T";				\
	   fi;					\
	   echo "<img src=\"https://github.com/guillaumef/wing-servo-frame/blob/master/$$file\" width=\"180\" alt=\"$$N frame\" />" >> GIFSHOW.md;			\
	 done;					\
	 rm -f list.tmp;

cleanstl:
	@rm -f stls/*/*.stl

cleangif:
	@rm -f stls/*/*.gif

clean:	cleanstl cleangif



help:
	@echo " ... only for automation of the examples"
	@echo "  - examples"
	@echo "  - list"
	@echo "  - sync"


list:
	@for tg in `grep 'Servo #' servo-frame.scad | sed -e 's/.*#//' | sed -e 's/ *- */ /' | sed -e 's/[*].*//' | sed -e 's/  */ /' | sed -e 's/ *$$//' | sed -e 's/ /,/g'`; do \
		SERV_BRAND=`echo "$$tg" | cut -f 1 -d ','`;					\
		SERV_SERVO=`echo "$$tg" | cut -f 2 -d ','`;					\
		SERV_NAME=`echo "$$tg" | sed -e 's/^[0-9]*,[0-9]*,//' | sed -e 's/,/ /g'`;	\
		echo "# $$SERV_BRAND,$$SERV_SERVO	: $$SERV_NAME";\
	done;

sync:
	@sed -e '/^Servo list:/,$$d' README.md > README.md.tmp
	@/bin/echo -e "Servo list:\n" >> README.md.tmp
	@for tg in `grep 'Servo #' servo-frame.scad | sed -e 's/.*#//' | sed -e 's/ *- */ /' | sed -e 's/[*].*//' | sed -e 's/  */ /' | sed -e 's/ *$$//' | sed -e 's/ /,/g'`; do \
		SERV_BRAND=`echo "$$tg" | cut -f 1 -d ','`;					\
		SERV_SERVO=`echo "$$tg" | cut -f 2 -d ','`;					\
		SERV_NAME=`echo "$$tg" | sed -e 's/^[0-9]*,[0-9]*,//' | sed -e 's/,/ /g'`;	\
		echo "- $$SERV_NAME" >> README.md.tmp;\
	 done;
	@mv README.md.tmp README.md

examples: sync
	@for tg in `grep 'Servo #' servo-frame.scad | sed -e 's/.*#//' | sed -e 's/ *- */ /' | sed -e 's/[\/|(*].*//' | sed -e 's/  */ /' | sed -e 's/ *$$//' | sed -e 's/ /,/g'`; do \
		SERV_BRAND=`echo "$$tg" | cut -f 1 -d ','`;					\
		SERV_SERVO=`echo "$$tg" | cut -f 2 -d ','`;					\
		SERV_NAME=`echo "$$tg" | sed -e 's/^[0-9]*,[0-9]*,//' | sed -e 's/,/-/g'`;	\
		echo "$$SERV_BRAND + $$SERV_SERVO => $$SERV_NAME";\
		openscad -D _servo_id_brand=$$SERV_BRAND 		\
			-D _servo_id_servo=$$SERV_SERVO			\
			-D with_bearing=3				\
			-o stl_examples/frame-$$SERV_NAME.echo		\
			servo-frame.scad;				\
		openscad -D _servo_id_brand=$$SERV_BRAND 		\
			-D _servo_id_servo=$$SERV_SERVO			\
			-D with_bearing=3				\
			-q						\
			-o stl_examples/frame-$$SERV_NAME-all.stl	\
			servo-frame.scad;				\
		openscad -D _servo_id_brand=$$SERV_BRAND 		\
			-D _servo_id_servo=$$SERV_SERVO			\
			-D with_bearing=1				\
			-q						\
			-o stl_examples/frame-$$SERV_NAME-r-bearing.stl	\
			servo-frame.scad;				\
		openscad -D _servo_id_brand=$$SERV_BRAND 		\
			-D _servo_id_servo=$$SERV_SERVO			\
			-D with_bearing=2				\
			-q						\
			-o stl_examples/frame-$$SERV_NAME-l-bearing.stl	\
			servo-frame.scad;				\
		openscad -D _servo_id_brand=$$SERV_BRAND 		\
			-D _servo_id_servo=$$SERV_SERVO			\
			-D with_bearing=0				\
			-q						\
			-o stl_examples/frame-$$SERV_NAME-no-bearing.stl \
			servo-frame.scad;				\
	 done;


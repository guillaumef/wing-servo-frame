
help:
	@echo " ... only for automation of the examples"
	@echo "  - examples"



examples:
	@for tg in `grep 'Servo #' servo-frame.scad | sed -e 's/.*#//' | sed -e 's/ *- */ /' | sed -e 's/[\/|(*].*//' | sed -e 's/  */ /' | sed -e 's/ *$$//' | sed -e 's/ /,/g'`; do \
		SERV_BRAND=`echo "$$tg" | cut -f 1 -d ','`;					\
		SERV_SERVO=`echo "$$tg" | cut -f 2 -d ','`;					\
		SERV_NAME=`echo "$$tg" | sed -e 's/^[0-9]*,[0-9]*,//' | sed -e 's/,/-/g'`;	\
		echo "$$SERV_BRAND + $$SERV_SERVO => $$SERV_NAME";\
		openscad -D _servo_id_brand=$$SERV_BRAND 	\
			-D _servo_id_servo=$$SERV_SERVO		\
			-q					\
			-o stl_examples/frame-$$SERV_NAME.stl		\
			servo-frame.scad;			\
	 done;


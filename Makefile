OSNF_DIR = osnf

.PHONY: osnf_code cleanall
CLEANDIRS = $(OSNF_CODE) ./

DEBUG=
FOR = gfortran -c  #-fno-underscoring 
FOR2 = gfortran  #-fno-underscoring 

AR = ar 
RANLIB = ranlib 
OBJ = o

OPT=-O3

FFLAGS =  $(OPT) -o # use with gfortran - need to use 32 bit memory model for now as memory locations are saved to 32 bit integer.

FFLAGS2 =  $(OPT) $(DEBUG) -o # use with gfortran - need to use 32 bit memory model for now as memory locations are saved to 32 bit integer.

adiabatic.exe	:  adiabatic_lib.a  adiabatic.$(OBJ) main.$(OBJ) osnf_code
	$(FOR2) $(FFLAGS2)adiabatic.exe adiabatic.$(OBJ) main.$(OBJ) \
	 -lm adiabatic_lib.a 

adiabatic_lib.a	:   osnf_code

	$(AR) rc adiabatic_lib.a $(OSNF_DIR)/numerics.$(OBJ) $(OSNF_DIR)/zeroin.$(OBJ) $(OSNF_DIR)/sfmin.$(OBJ) \
				$(OSNF_DIR)/fmin.$(OBJ) $(OSNF_DIR)/r1mach.$(OBJ) \
                $(OSNF_DIR)/d1mach.$(OBJ) $(OSNF_DIR)/dfsid1.$(OBJ) \
                $(OSNF_DIR)/poly_int.$(OBJ) $(OSNF_DIR)/find_pos.$(OBJ) \
                $(OSNF_DIR)/svode.$(OBJ) \
                $(OSNF_DIR)/slinpk.$(OBJ) $(OSNF_DIR)/vode.$(OBJ) \
                $(OSNF_DIR)/dlinpk.$(OBJ) $(OSNF_DIR)/vode_integrate.$(OBJ) \
                $(OSNF_DIR)/erfinv.$(OBJ) $(OSNF_DIR)/tridiagonal.$(OBJ) \
                $(OSNF_DIR)/hygfx.$(OBJ) $(OSNF_DIR)/random.$(OBJ)			

adiabatic.$(OBJ)   : adiabatic.f90 osnf_code
	$(FOR) -cpp adiabatic.f90 $(FFLAGS)adiabatic.$(OBJ) 
main.$(OBJ)   : main.f90 adiabatic.$(OBJ) osnf_code
	$(FOR) -cpp main.f90 $(FFLAGS)main.$(OBJ) 
	
osnf_code:
	$(MAKE) -C $(OSNF_DIR)

clean: 
	rm *.exe  *.o *.mod *~ \
	adiabatic_lib.a

cleanall:
	for i in $(CLEANDIRS); do \
		$(MAKE) -C $$i clean; \
	done
	
	

DEBUG=
FOR = gfortran -c  #-fno-underscoring 
FOR2 = gfortran  #-fno-underscoring 

AR = ar 
RANLIB = ranlib 
OBJ = o

OPT=-O3

FFLAGS =  $(OPT) -o # use with gfortran - need to use 32 bit memory model for now as memory locations are saved to 32 bit integer.

FFLAGS2 =  $(OPT) $(DEBUG) -o # use with gfortran - need to use 32 bit memory model for now as memory locations are saved to 32 bit integer.

adiabatic.exe	:  adiabatic_lib.a  adiabatic.$(OBJ) main.$(OBJ)
	$(FOR2) $(FFLAGS2)adiabatic.exe adiabatic.$(OBJ) main.$(OBJ) \
	 -lm adiabatic_lib.a 

adiabatic_lib.a	:   nrtype.$(OBJ) nr.$(OBJ) nrutil.$(OBJ) zbrent.$(OBJ) trapzd.$(OBJ) \
                    qsimp.$(OBJ) polint.$(OBJ) locate.$(OBJ) qromb.$(OBJ) brent.$(OBJ) \
                    midpnt.$(OBJ) dfridr.$(OBJ) fmin.$(OBJ) broydn.$(OBJ) fdjac.$(OBJ) \
                    qrdcmp.$(OBJ) qrupdt.$(OBJ) rsolv.$(OBJ) lnsrch.$(OBJ) rotate.$(OBJ) \
                    pythag.$(OBJ) d1mach.$(OBJ) vode.$(OBJ) dlinpk.$(OBJ) acdc.$(OBJ) \
                    colmod.$(OBJ) opkdmain.$(OBJ) opkda1.$(OBJ) opkda2.$(OBJ) rkqs.$(OBJ) \
                    rkck.$(OBJ) odeint.$(OBJ)

	$(AR) rc adiabatic_lib.a nrtype.$(OBJ) nr.$(OBJ) nrutil.$(OBJ) zbrent.$(OBJ) trapzd.$(OBJ) \
	                qsimp.$(OBJ) polint.$(OBJ) locate.$(OBJ) qromb.$(OBJ) brent.$(OBJ) \
	                midpnt.$(OBJ) dfridr.$(OBJ) fmin.$(OBJ) broydn.$(OBJ) fdjac.$(OBJ) \
	                qrdcmp.$(OBJ) qrupdt.$(OBJ) rsolv.$(OBJ) lnsrch.$(OBJ) rotate.$(OBJ) \
	                pythag.$(OBJ) d1mach.$(OBJ) vode.$(OBJ) dlinpk.$(OBJ) acdc.$(OBJ) \
	                colmod.$(OBJ) opkdmain.$(OBJ) opkda1.$(OBJ) opkda2.$(OBJ) rkqs.$(OBJ) \
	                rkck.$(OBJ) odeint.$(OBJ); $(RANLIB) adiabatic_lib.a

zbrent.$(OBJ)	: ./nr/zbrent.f90
	$(FOR) ./nr/zbrent.f90 $(FFLAGS)zbrent.$(OBJ)
trapzd.$(OBJ)	: ./nr/trapzd.f90
	$(FOR) ./nr/trapzd.f90 $(FFLAGS)trapzd.$(OBJ)
qsimp.$(OBJ)	: ./nr/qsimp.f90
	$(FOR) ./nr/qsimp.f90 $(FFLAGS)qsimp.$(OBJ)
polint.$(OBJ)	: ./nr/polint.f90
	$(FOR) ./nr/polint.f90 $(FFLAGS)polint.$(OBJ)
locate.$(OBJ)	: ./nr/locate.f90
	$(FOR) ./nr/locate.f90 $(FFLAGS)locate.$(OBJ)
qromb.$(OBJ)	: ./nr/qromb.f90
	$(FOR) ./nr/qromb.f90 $(FFLAGS)qromb.$(OBJ)
brent.$(OBJ)	: ./nr/brent.f90
	$(FOR) ./nr/brent.f90 $(FFLAGS)brent.$(OBJ)
midpnt.$(OBJ)	: ./nr/midpnt.f90
	$(FOR) ./nr/midpnt.f90 $(FFLAGS)midpnt.$(OBJ)
fmin.$(OBJ)	: ./nr/fmin.f90
	$(FOR) ./nr/fmin.f90 $(FFLAGS)fmin.$(OBJ)
broydn.$(OBJ)	: ./nr/broydn.f90
	$(FOR) ./nr/broydn.f90 $(FFLAGS)broydn.$(OBJ)
fdjac.$(OBJ)	: ./nr/fdjac.f90
	$(FOR) ./nr/fdjac.f90 $(FFLAGS)fdjac.$(OBJ)
qrdcmp.$(OBJ)	: ./nr/qrdcmp.f90
	$(FOR) ./nr/qrdcmp.f90 $(FFLAGS)qrdcmp.$(OBJ)
qrupdt.$(OBJ)	: ./nr/qrupdt.f90
	$(FOR) ./nr/qrupdt.f90 $(FFLAGS)qrupdt.$(OBJ)
rkqs.$(OBJ)	: ./nr/rkqs.f90
	$(FOR) ./nr/rkqs.f90 $(FFLAGS)rkqs.$(OBJ)
rkck.$(OBJ)	: ./nr/rkck.f90
	$(FOR) ./nr/rkck.f90 $(FFLAGS)rkck.$(OBJ)
odeint.$(OBJ)	: ./nr/odeint.f90
	$(FOR) ./nr/odeint.f90 $(FFLAGS)odeint.$(OBJ)
rsolv.$(OBJ)	: ./nr/rsolv.f90
	$(FOR) ./nr/rsolv.f90 $(FFLAGS)rsolv.$(OBJ)
lnsrch.$(OBJ)	: ./nr/lnsrch.f90
	$(FOR) ./nr/lnsrch.f90 $(FFLAGS)lnsrch.$(OBJ)
rotate.$(OBJ)	: ./nr/rotate.f90
	$(FOR) ./nr/rotate.f90 $(FFLAGS)rotate.$(OBJ)
pythag.$(OBJ)	: ./nr/pythag.f90
	$(FOR) ./nr/pythag.f90 $(FFLAGS)pythag.$(OBJ)
dfridr.$(OBJ)	: ./nr/dfridr.f90
	$(FOR) ./nr/dfridr.f90 $(FFLAGS)dfridr.$(OBJ)
nrtype.$(OBJ)	: ./nr/nrtype.f90
	$(FOR) ./nr/nrtype.f90 $(FFLAGS)nrtype.$(OBJ)
nr.$(OBJ)	: ./nr/nr.f90 
	$(FOR) ./nr/nr.f90 $(FFLAGS)nr.$(OBJ)
nrutil.$(OBJ)	: ./nr/nrutil.f90
	$(FOR) ./nr/nrutil.f90 $(FFLAGS)nrutil.$(OBJ)
adiabatic.$(OBJ)   : adiabatic.f90 
	$(FOR) -cpp adiabatic.f90 $(FFLAGS)adiabatic.$(OBJ) 
main.$(OBJ)   : main.f90 adiabatic.$(OBJ) 
	$(FOR) -cpp main.f90 $(FFLAGS)main.$(OBJ) 

d1mach.$(OBJ) 	: ./netlib/d1mach.f 
	$(FOR) 	./netlib/d1mach.f $(FFLAGS)d1mach.$(OBJ)  
opkdmain.$(OBJ) : ./netlib/opkdmain.f 
	$(FOR) 	./netlib/opkdmain.f $(FFLAGS)opkdmain.$(OBJ)
opkda1.$(OBJ) : ./netlib/opkda1.f 
	$(FOR) 	./netlib/opkda1.f -w $(FFLAGS)opkda1.$(OBJ)
opkda2.$(OBJ) : ./netlib/opkda2.f 
	$(FOR) ./netlib/opkda2.f -w $(FFLAGS)opkda2.$(OBJ)
vode.$(OBJ) : ./netlib/vode.f 
	$(FOR) 	./netlib/vode.f -Wno-all $(FFLAGS)vode.$(OBJ)
acdc.$(OBJ) : ./netlib/acdc.f 
	$(FOR) 	./netlib/acdc.f $(FFLAGS)acdc.$(OBJ)
dlinpk.$(OBJ) : ./netlib/dlinpk.f 
	$(FOR) 	./netlib/dlinpk.f -w $(FFLAGS)dlinpk.$(OBJ)
colmod.$(OBJ) : ./netlib/colmod.f 
	$(FOR) 	./netlib/colmod.f -Wno-all $(FFLAGS)colmod.$(OBJ)
derf.$(OBJ) : 	./netlib/erf.f ./netlib/callerf.h
	$(FOR) ./netlib/erf.f $(FFLAGS)derf.$(OBJ) 
hygfx.$(OBJ) : ./netlib/hygfx.for ./netlib/hypergeom1.h
	$(FOR) ./netlib/hygfx.for $(FFLAGS)hygfx.$(OBJ) 
gamma.$(OBJ) : ./netlib/gamma.for ./netlib/hypergeom1.h
	$(FOR) ./netlib/gamma.for $(FFLAGS)gamma.$(OBJ) 
psi.$(OBJ) : ./netlib/psi.for ./netlib/hypergeom1.h
	$(FOR) ./netlib/psi.for $(FFLAGS)psi.$(OBJ) 
lmdif.$(OBJ) : ./netlib/lmdif.f ./netlib/lmdif.h
	$(FOR) ./netlib/lmdif.f $(FFLAGS)lmdif.$(OBJ)
dpmpar.$(OBJ) : ./netlib/dpmpar.f 
	$(FOR) ./netlib/dpmpar.f $(FFLAGS)dpmpar.$(OBJ) 
enorm.$(OBJ) : ./netlib/enorm.f 
	$(FOR) ./netlib/enorm.f $(FFLAGS)enorm.$(OBJ) 
fdjac2NL.$(OBJ) : ./netlib/fdjac2.f 
	$(FOR) ./netlib/fdjac2.f $(FFLAGS)fdjac2NL.$(OBJ) 	
lmpar.$(OBJ) : ./netlib/lmpar.f 
	$(FOR) ./netlib/lmpar.f $(FFLAGS)lmpar.$(OBJ) 	
qrfac.$(OBJ) : ./netlib/qrfac.f 
	$(FOR) ./netlib/qrfac.f $(FFLAGS)qrfac.$(OBJ) 	
qrsolv.$(OBJ) : ./netlib/qrsolv.f 
	$(FOR) ./netlib/qrsolv.f $(FFLAGS)qrsolv.$(OBJ) 	

clean :
	rm *.exe  *.o *.mod *~ \
	adiabatic_lib.a


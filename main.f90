	!> @mainpage
	!>@author
	!>Paul J. Connolly, The University of Manchester
	!>@copyright 2018
	!>@brief
	!>Adiabatic Parcel Model (APM): 
	!>Solves a simple adiabatic parcel model for calculating adiabatic liquid water
	!> <br>
	!> compile using the Makefile  and then run using: <br>
	!> ./adiabatic.exe 290. 100000. 80000. 0.7 0 100. 15 <br>
	!> Arguments are: initial temperature, pressure; final pressure; initial RH;
	!> initial height; drop number concentration (number per mg of air); dz step
	!> <br><br>

	!>@author
	!>Paul J. Connolly, The University of Manchester
	!>@brief
    !>main programme reads command line arguments and prints to stout
	program adiabatic
        use numerics_type
        use adiabatic_vars
        use numerics, only : fmin, vode_integrate
        implicit none
        real(wp) :: t,t1,p,dp1,theta,tinit,pinit,pfinal, &
                 rhinit,ws,theta_q_sat,almr=0._wp,z,dz,plcl,tlcl,ndrop, eps2,hmin,htry
        real(wp), dimension(1) :: p11
        character (len=100) :: readstr = ' '

        ! initial conditions
!         tinit=293.15
!         pinit=100000._wp
!         pfinal=10000._wp
!         rhinit=1._wp
!         rhinit=min(rhinit,1._wp)
!         z=0._wp
!         dz=500._wp
!         
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! read from command line                                                         !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        call getarg(1,readstr)
        read (readstr,*) tinit

        call getarg(2,readstr)
        read (readstr,*) pinit

        call getarg(3,readstr)
        read (readstr,*) pfinal

        call getarg(4,readstr)
        read (readstr,*) rhinit
        rhinit=min(rhinit,0.999d0)

        call getarg(5,readstr)
        read (readstr,*) z

        call getarg(6,readstr)
        read (readstr,*) ndrop
        ndrop=ndrop*1d6

        call getarg(7,readstr)
        read (readstr,*) dz
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! set variables                                                                  !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        p=pinit
        t=tinit
        t1=tinit
        p111=p
        ws=eps*svp_liq(t)/(p-svp_liq(t))
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! find lcl                                                                       !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! dry potential temperature
        theta=t*(100000._wp/p)**(ra/cp)
        theta_surf=theta
        ! find the pressure at which rh=1.0
        theta111=theta
        w111=rhinit*eps*svp_liq(tinit)/(pinit-svp_liq(tinit))
        ! find LCL
        plcl=fmin(pfinal,pinit,find_lcl,1.e-5_wp)
        plcl1=plcl
        tlcl=theta*(plcl/100000._wp)**(ra/cp)
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! find moist potential temp                                                      !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        theta_q_sat=tlcl*(100000._wp/plcl)**(ra/cp)*dexp(lv*w111/cp/tlcl)
        theta_q_sat111=theta_q_sat
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! print some stuff                                                               !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        write(*,"(a20,a20)") 'theta','theta_q (lcl)<br>'
        write(*,"(f20.5,f20.5,a)") theta,theta_q_sat,'<br>'
        write(*,*) '<table border="1">'
        write(*,"(a20,a20,a20,a20,a20,a20)") '<td>tdry (k)','<td>tmoist (k)','<td>pressure (pa)', &
          '<td>z (m)','<td>lwmr (kg kg-1)','<td>d (um)'
        print *,t,t1,p, z, almr,(6._wp*(almr/ndrop)/pi/1000._wp)**(1._wp/3._wp)*1.e6_wp
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! loop in steps of dz until min pressure reached                                 !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        do while(p.gt.pfinal)

            ! work out pressure
            !dp1=-dz*p/ra/t*grav

            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            ! solve for pressure (conserving either dry or moist potential temperature)  !
            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            htry=dz
            eps2=1.e-8_wp
            hmin=1.e-2_wp
            p11(1)=p
            t1old=t
            call vode_integrate(p11,z,z+dz,eps2,htry,hmin,hydrostatic2a)
            p=p11(1)
            p111=p
            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            
            
            

            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            ! calculate temperature and lwmr                                             !
            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            t=theta*(p/100000._wp)**(ra/cp)
            ! find the temperature where theta_q_sat is conserved
            t1old=t1
            if(p.gt.plcl) then
              t1=t
              almr=0._wp
            else
              t1=fmin(t,t1old*1.01_wp,calc_theta_q,1.e-5_wp)
              almr=eps*svp_liq(tlcl)/(plcl-svp_liq(tlcl))-eps*svp_liq(t1)/(p-svp_liq(t1))
            endif
            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




            z=z+dz
            print *,t,t1,p, z, almr,(6._wp*(almr/ndrop)/pi/1000._wp)**(1._wp/3._wp)*1.e6_wp
   
            t=t1
        end do
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                                    
    end program adiabatic
     
   


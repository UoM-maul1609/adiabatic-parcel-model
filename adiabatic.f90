	!>@author
	!>Paul Connolly, The University of Manchester
	!>@brief
	!>routines for simple adiabatic parcel model
    module adiabatic_vars
        use nrtype
        implicit none
        public 
        !private ::
        real(sp), parameter :: r_gas=8.314_sp, ma=29.e-3_sp,mw=18.e-3_sp, &
                                ra=r_gas/ma,rv=r_gas/mw,cp=1005._sp, &
                                eps=ra/rv,lv=2.5e6_sp, ttr=273.15_sp, grav=9.81_sp
        real(sp) :: p111,w111,theta111,theta_q_sat111, theta_surf,t1old,plcl1
        
        
        contains
        
        
        
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! saturation vapour pressure over liquid                                       !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        !>@author
        !>Paul J. Connolly, The University of Manchester
        !>@brief
        !>calculates the saturation vapour pressure over liquid water according to buck fit
        !>@param[in] t: temperature
        !>@return svp_liq: saturation vapour pressure over liquid water
        function svp_liq(t)
            use nrtype
            implicit none
            real(sp), intent(in) :: t
            real(sp) :: svp_liq
            svp_liq = 100._sp*6.1121_sp* &
                  exp((18.678_sp - (t-ttr)/ 234.5_sp)* &
                  (t-ttr)/(257.14_sp + (t-ttr)))
        end function svp_liq

        
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! moist potential temperature                                                  !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        !>@author
        !>Paul J. Connolly, The University of Manchester
        !>@brief
        !>calculates the moist potential temperature
        !>@param[in] t: temperature
        !>@return calc_theta_q: theta_q - 
        !> can also be used to root-find if theta_q_sat111 set
        function calc_theta_q(t111)
            use nrtype
            implicit none
            real(sp), intent(in) :: t111
            real(sp) :: calc_theta_q
            real(sp) :: ws
            ws=eps*svp_liq(t111)/(p111-svp_liq(t111))
            calc_theta_q=t111*(100000._sp/p111)**(ra/cp)*exp(lv*ws/cp/t111)-theta_q_sat111

        end function calc_theta_q     

        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! lcl                                                  !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        !>@author
        !>Paul J. Connolly, The University of Manchester
        !>@brief
        !>root-finder helper for finding lcl
        !>@param[in] p: pressure
        !>@return find_lcl: zero if at lcl
        function find_lcl(plcl)
            use nrtype
            implicit none
            real(sp), intent(in) :: plcl
            real(sp) :: find_lcl
            real(sp) :: ws,tlcl
            tlcl=theta111*(plcl/100000._sp)**(ra/cp)
            ! calculate the mixing ratio
            ws=eps*svp_liq(tlcl)/(plcl-svp_liq(tlcl))

            find_lcl=ws-w111 ! w111 is the mixing ratio at the start

        end function find_lcl  
        
        
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ! find dpdz                                                                    !
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        !>@author
        !>Paul J. Connolly, The University of Manchester
        !>@brief
        !>calculates the moist potential temperature
        !>@param[in] z: height
        !>@param[in] p: pressure
        !>@param[out] dpdz: derivative of p wrt z
        !> used to find pressure along adiabat
        subroutine hydrostatic2a(z,p,dpdz)
            use nrtype
            use nr, only : zbrent
            implicit none
            real(sp), intent(in) :: z
            real(sp), dimension(:), intent(in) :: p
            real(sp), dimension(:), intent(out) :: dpdz
            real(sp) :: t
    
            p111=p(1)
            ! estimate the temperature using dry adiabat
            t=theta_surf*(p111/1.e5_sp)**(ra/cp)
            if(p(1)<plcl1) then
                t=zbrent(calc_theta_q,t,t1old*1.01_sp,1.e-5_sp)
            endif
            ! find the temperature by iteration
            dpdz(1)=-(grav*p(1))/(ra*t)
    
        end subroutine hydrostatic2a
        
    end module adiabatic_vars


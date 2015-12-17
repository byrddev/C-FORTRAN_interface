module add_basic

use ISO_C_BINDING

implicit none


integer(4) :: testint=5
real(8) :: testreal=5.0157

contains

integer(4) function add2i(x, y) bind(C, name="add2i")
  integer(4), intent(in) :: x, y
  add2i = x + y + testint
end function add2i

real(8) function add2r(x, y) bind(C, name="add2r")
  real(8), intent(in) :: x, y
  add2r = x + y + testreal
end function add2r

subroutine VecRef( v, total) bind(C, name="VecRef")
integer(4) i, total, v(9)
total = 0
do i = 1,9
  total = total + v(i)
end do
end subroutine VecRef

subroutine VecRefr(vr, wr) bind(C, name="VecRefr")
integer(4) i
real(8), intent(in) :: vr(9)
real(8), intent(out) :: wr(3)
wr(1) = 0
wr(2) = 0
wr(3) = 0
do i = 1,3
  wr(1) = wr(1) + vr(i)
  wr(2) = wr(2) + vr(i+3)
  wr(3) = wr(3) + vr(i+6)
end do
end subroutine VecRefr

subroutine VecRefrvarlenght(vr_var, nvr_var, wr_var, nwr_var) bind(C, name="VecRefrvarlenght")
integer(4) i_var, nvr_var, nwr_var
real(8), intent(in) :: vr_var(nvr_var)
real(8), intent(out) :: wr_var(nwr_var)
wr_var(1) = 0
wr_var(2) = 0
wr_var(3) = 0
do i_var = 1,3
  wr_var(1) = wr_var(1) + vr_var(i_var)
  wr_var(2) = wr_var(2) + vr_var(i_var+3)
  wr_var(3) = wr_var(3) + vr_var(i_var+6)
end do
end subroutine VecRefrvarlenght

subroutine VecRefRvarlenght_opt(vr_varo, nvr_varo, wr_varo, nwr_varo, ios) bind(C, name="VecRefRvarlenght_opt")
integer(4) i_varo, nvr_varo, nwr_varo
real(8), intent(in) :: vr_varo(nvr_varo)
real(8), intent(out) :: wr_varo(nwr_varo)
integer(4), intent(out) :: ios
ios = 0
!if(present(ios))ios=0  can only use 'present' if variable is optional, dropped for C compatibility
wr_varo(1) = 0
wr_varo(2) = 0
wr_varo(3) = 0
do i_varo = 1,3
  wr_varo(1) = wr_varo(1) + vr_varo(i_varo)
  wr_varo(2) = wr_varo(2) + vr_varo(i_varo+3)
  wr_varo(3) = wr_varo(3) + vr_varo(i_varo+6)
end do
end subroutine VecRefRvarlenght_opt

subroutine VecRefRvarlenght_opt2(vr_varo2, wr_varo2, ios2) bind(C, name="VecRefRvarlenght_opt2")  ! check the * for assumed dimension arrays
integer(4) i_varo2, sizevr_varo2
real(8), intent(in) :: vr_varo2(*)
real(8), intent(out) :: wr_varo2(*)
integer(4), intent(out) :: ios2
ios2 = 0
!if(present(ios))ios=0  can only use 'present' if variable is optional, dropped for C compatibility
wr_varo2(1) = 0
wr_varo2(2) = 0
wr_varo2(3) = 0
do i_varo2 = 1,3
  wr_varo2(1) = wr_varo2(1) + vr_varo2(i_varo2)
  wr_varo2(2) = wr_varo2(2) + vr_varo2(i_varo2+3)
  wr_varo2(3) = wr_varo2(3) + vr_varo2(i_varo2+6)
end do
write (*,*) ">",size(vr_varo2, 2),"<"
end subroutine VecRefRvarlenght_opt2

subroutine passstringtest(instring, ninstring) bind(C, name="passstringtest")
  integer :: ninstring
  character(kind=c_char, len=1), dimension(ninstring), intent(in) :: instring
  write (*,*) ">", instring, "<"
end subroutine passstringtest

subroutine print_hi_array(input_string, ninput_string) bind(C, name="print_hi_array")
  integer :: iprint, j
  integer(4), intent (in)  :: ninput_string
  character (kind=c_char, len=1), dimension (255, ninput_string), intent (in) :: input_string
  character (kind=c_char, len=255) :: translatedstring(ninput_string)

  write (*,*) ">",input_string,"<"
  write (*,*) ">",input_string(:,1),"<"
  write (*,*) ">",input_string(:,2),"<"
  write (*,*) ">",input_string(:,3),"<"
  !write (*,*) ">",trim(translatedstring(1)),"<"

  do j = 1 , ninput_string
    translatedstring(j) = c_null_char
    do iprint = 1, 255
      if (input_string(iprint, j) .ne.  c_null_char) then
        write (*,*) "iprint ",iprint, j, input_string(iprint, j)
        translatedstring(j)(iprint:iprint) = input_string(iprint, j)
      endif
    enddo
  enddo

  write (*,*) ">",translatedstring(1),"<"

  write (*,*) ">",trim(translatedstring(1)),"<"
  write (*,*) ">",trim(translatedstring(2)),"<"
  write (*,*) ">",trim(translatedstring(3)),"<"

end subroutine print_hi_array

real function simpson(f, a, b, n) ! haven't tried passing function pointers without ISO C bindings
  ! Approximate the definite integral of f from a to b by the
  ! composite Simpson's rule, using N subintervals
  ! see: <a href="http://en.wikipedia.org/wiki/Simpson%27s_rule">http://en.wikipedia.org/wiki/Simpson%27s_rule</a>
  ! function arguments ---------------------
  ! f: real function
  interface
    real function f(x)
      real, intent(in) :: x
    end function f
  end interface
  ! [a, b] : the interval of integration
  real, intent(in) ::  a, b
  ! n : number of subintervals used
  integer, intent(in) :: n
  ! ----------------------------------------
  ! temporary variables
  integer :: k
  real :: s
  s = 0
  do k=1, n-1
    s = s + 2**(mod(k,2)+1) * f(a + (b-a)*k/n)
  end do
  simpson = (b-a) * (f(a) + f(b) + s) / (3*n)
end function simpson

end module add_basic

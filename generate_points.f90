program generate_points
implicit none
integer :: i
integer :: npoints
real(8) :: max_v, min_v
real(8) :: inp, output
real(8) :: step, func

read(*,*) npoints, max_v, min_v
step = (max_v - min_v) / (npoints + 1)
open(10,file='points.dat',status='replace')
write(10,*) npoints
do i=1, npoints
   inp = i * step + min_v
   output = func(inp)
   write(10,*) -inp, output
enddo

endprogram

real(8) function func(x)
implicit none
real(8) :: x
real(8), parameter :: De = 1.4d0 
real(8), parameter :: xe = 1.5d0
real(8), parameter :: a = 1.2d0

func = De * (1d0-dexp(-a*(x-xe)))**2
endfunction

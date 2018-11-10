program evaluate
implicit none
integer :: i
! NN structure
integer :: inp_s, h1_s, out_s
real(8), dimension(:,:), allocatable :: w1, w2
real(8), dimension(:), allocatable :: b1, b2

! Data to evaluate
integer :: ndata
real(8) :: inp_read, out_read
real(8),dimension(:,:), allocatable :: input, output, targ
real(8),dimension(:,:), allocatable :: h1, dummy1, dummy2

open(10,file='NN_param',status='old')

read(10,*) inp_s, h1_s, out_s
allocate(w1(h1_s,inp_s), b1(h1_s))
allocate(w2(out_s,h1_s), b2(out_s))

do i=1,h1_s
   read(10,*) w1(i,:), b1(i)
enddo
do i=1,out_s
   read(10,*) w2(i,:), b2(i)
enddo

! Read data to evaluate
read(*,*) ndata
allocate(input(inp_s,ndata), output(out_s,ndata), targ(out_s,ndata))
allocate(h1(h1_s,ndata), dummy1(h1_s,ndata),dummy2(h1_s,ndata))
do i=1,ndata
   read(*,*) inp_read, out_read
   input(:,i) = inp_read
   targ(:,i) = out_read
enddo

call step(ndata, inp_s, h1_s,     input, h1,     w1, b1, dummy1, .TRUE.)
call step(ndata, h1_s,  out_s, h1,    output, w2, b2, dummy2, .FALSE.)
write(*,*) '# Input, output, target'
do i=1,ndata
   write(*,*) input(:,i),output(:,i), targ(:,i)
enddo
endprogram

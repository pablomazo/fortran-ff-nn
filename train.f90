program fit
implicit none
integer, parameter :: maxepochs = 10000
real(8), parameter :: lr = 1e-1
! Neural Network layers sizes:
integer, parameter :: inp_s=1, h1_s=20, output_s=1

! Parameters of the NN:
real(8) :: w1(h1_s,inp_s), b1(h1_s) ! Conects I->H1
real(8) :: w2(output_s,h1_s), b2(output_s) ! Conects H1->O


! Layers:
real(8), dimension(:,:), allocatable :: h1, output

! Derivatives wrt input in each layer:
real(8), dimension(:,:), allocatable :: dh1, doutput

!Derivative of sigmoids in each layer:
real(8), dimension(:,:), allocatable :: dsig1, dsig2

! Derivative of mse error
real(8) :: mse
real(8), dimension(:,:), allocatable :: mse_der

! Read data.
integer :: ndata, i
real(8), dimension(:,:), allocatable :: input_data, targ
real(8), dimension(inp_s) :: input_read
real(8), dimension(output_s) :: targ_read

integer :: epoch

read(*,*) ndata
allocate(input_data(inp_s,ndata), targ(output_s,ndata))
allocate(h1(h1_s,ndata), output(output_s,ndata))
allocate(dh1(h1_s,ndata), doutput(output_s,ndata))
allocate(dsig1(h1_s,ndata), dsig2(output_s,ndata))
allocate(mse_der(output_s, ndata))

input_data = 0d0
targ = 0d0
do i=1,ndata
   read(*,*) input_read(:), targ_read(:)
   input_data(:,i) = input_read
   targ(:,i) = targ_read
enddo

! Random Initialization of weights and bias in the NN:
call RANDOM_NUMBER(w1)
call RANDOM_NUMBER(b1)

call RANDOM_NUMBER(w2)
call RANDOM_NUMBER(b2)

open(10,file='output_values',status='replace')
write(10,*) '# Input, output, target'
open(12,file='NN_param', status='replace')
write(*,*) '# Epoch | MSE'
do epoch=1,maxepochs
! Forward pass:
call step(ndata, inp_s, h1_s,     input_data, h1,     w1, b1, dsig1, .TRUE.)
call step(ndata, h1_s,  output_s, h1,         output, w2, b2, dsig2, .FALSE.)

! Calculate derivative of error:
call get_mse(ndata, output_s, output, targ, mse, mse_der)
write(*,*) epoch, mse

! Backward pass:
doutput = mse_der
call backward(ndata, output_s, h1_s, w2, dsig1, doutput, dh1)

! Update weights and bias:
call update(ndata, inp_s, h1_s,     input_data, dh1,     w1, b1, lr)
call update(ndata, h1_s,  output_s, h1,         doutput, w2, b2, lr)
enddo

do i=1,ndata
   write(10,*) input_data(:,i),output(:,i), targ(:,i)
enddo

! Write NN parameters to evaluate
write(12,*) inp_s, h1_s, output_s
do i=1, h1_s
   write(12,*) w1(i,:), b1(i)
enddo

do i=1,output_s
   write(12,*) w2(i,:), b2(i)
enddo

endprogram


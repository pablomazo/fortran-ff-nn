subroutine update(ndata, l_s, l1_s, input, delta, w, b, lr)
implicit none
integer :: i,j,k
integer, intent(in) :: l_s, l1_s, ndata
real(8), dimension(l_s, ndata), intent(in) :: input
real(8), dimension(l1_s,ndata), intent(in) :: delta
real(8), intent(in) :: lr
real(8), dimension(l1_s, l_s), intent(inout) :: w
real(8), dimension(l1_s), intent(inout) :: b
real(8) :: iw(l1_s,l_s), ib(l1_s)

iw = 0d0
ib = 0d0
do i=1, l1_s
   do j=1,l_s
      do k=1,ndata
         iw(i,j) = iw(i,j) + delta(i,k) * input(j,k)
      enddo
   enddo
enddo 

do i=1,l1_s
   do j=1,ndata
      ib(i) = ib(i) + delta(i,j)   
   enddo
enddo

w = w - lr * iw
b = b - lr * ib

endsubroutine

subroutine backward(ndata, l1_s, l_s, w, dsig, delta_l1, delta_l)
implicit none
integer :: i,j,k
integer, intent(in) :: ndata, l1_s, l_s
real(8), dimension(l1_s, l_s), intent(in) :: w
real(8), dimension(l1_s,ndata), intent(in) :: delta_l1
real(8), dimension(l_s,ndata), intent(in) :: dsig
real(8), dimension(l_s, ndata), intent(out) :: delta_l
real(8) :: aux

delta_l = 0d0
do i=1,l_s
   do j=1,ndata
      aux=0d0
      do k = 1, l1_s
	     aux = aux + w(k,i) * delta_l1(k,j)
      enddo
	  delta_l(i,j) = aux * dsig(i,j)
   enddo
enddo
endsubroutine

subroutine get_mse(ndata, output_s, output, targ, mse, mse_der) 
implicit none
integer :: i
integer, intent(in) :: ndata, output_s
real(8), dimension(output_s,ndata), intent(in) :: output, targ
real(8), dimension(output_s,ndata), intent(out) :: mse_der 
real(8), intent(out) :: mse

mse = 0d0
mse_der = 0d0

do i=1,ndata
   mse_der(1,i) = output(1,i) - targ(1,i)
   mse = mse + mse_der(1,i) * mse_der(1,i)
enddo
mse_der = mse_der / ndata
mse = mse / ndata
mse = mse / 2d0 
endsubroutine

subroutine step(ndata,nl, nl1, input, output, w, b, dsig, activation)
implicit none
integer :: i, j, k
integer, intent(in) :: nl, nl1, ndata
real(8), intent(in) :: input(nl,ndata), w(nl1,nl), b(nl1)
logical, intent(in) :: activation
real(8), intent(out) :: output(nl1,ndata), dsig(nl1,ndata)
real(8) :: sig

output = 0d0
dsig = 0d0

do i=1,nl1
   do j=1,ndata
      do k=1,nl
         output(i,j) = output(i,j) + w(i,k) * input(k,j)         
      enddo
	  output(i,j) = output(i,j) + b(i)
	  if (activation) then
	     output(i,j) = sig(output(i,j))
	     dsig(i,j) = output(i,j) * (1d0 - output(i,j))
      else
	     dsig(i,j) = 1d0
	  endif
   enddo
enddo
endsubroutine

real(8) function sig(x)
implicit none
real(8) :: x
sig = 1d0 / (1d0 + dexp(-x))
endfunction

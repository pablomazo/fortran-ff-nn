FC=gfortran
FFLAGS=-O3

all: train evaluate generate

train:train.f90 routines.f90
	$(FC) $(FFLAGS) $^ -o train.x

evaluate:evaluate.f90 routines.f90
	$(FC) $(FFLAGS) $^ -o evaluate.x

generate:generate_points.f90
	$(FC) $^ -o generate_points.x

clean:
	rm -f *.x *.o *.mod

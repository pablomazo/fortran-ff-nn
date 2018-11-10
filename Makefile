FC=gfortran

all: fit evaluate generate

fit:fit.f90 routines.f90
	$(FC) $^ -o fit.x

evaluate:evaluate.f90 routines.f90
	$(FC) $^ -o evaluate.x

generate:generate_points.f90
	$(FC) $^ -o generate_points.x

clean:
	rm -f *.x *.o *.mod

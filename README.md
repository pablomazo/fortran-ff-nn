# Feed Forward Neural Network

Toy model of a feed forward NN coded in FORTRAN90.
It's just a one hidden layer NN but can be rewritten to be N hidden layer (although I don't
recommend it, it won't be practical).

This project is thought as an excercise for further understanding of what a NN is  and
how backpropagation works.

## Includes:
- train.f90: Training main program. Will read the set of (input,target) points and 
fit the NN weights and bias.
- evaluate.f90: When "fit.f90" ends, a file named "NN_parameters" is created. This
program loads this parameters and allows to evaluate the NN on any set of points.
- routines.f90: Some subroutines that both "train.f90" and "evaluate.f90" will use.
- generate_points.f90: This program is specific for each application. Just generates the
set of (input, target) points.
- Makefile

## Execution:
1. Use "generate_points.f90" with the function you want the NN to fit. Input a file with 3 values (number
of points you want to generate, maximum value of the input and minimum value of the input)
```
> cat generate_train.inp
  100  10e0   5e-1
> ./generate_points.x < generate_train.inp
```
This execution will output a file named "points.dat" with the set of training points.

2. Execute "train.x":
```
> ./train.x < points.dat > loss
```
"loss" will contain the mse loss for each epoch.

Two other files will be created:

* NN_param: File containing the Neural Network structure parameters in the 
first line and the weights and bias for the NN.
* ouput_values: File containing the list of (input, NN output, target)

3. Evaluate the model "evaluate.x":
Once your model is trained evaluate it on new points to check how good your model
is.
```
> ./evaluate.x < evaluation_points.dat > evaluation.out
```
"evaluation.out" will contain a list (input, NN output, target).

## Bibliograpy:
[Michael A. Nielsen, "Neural Networks and Deep Learning", Chapter 2, Determination Press, 2015](http://neuralnetworksanddeeplearning.com/chap2.html)

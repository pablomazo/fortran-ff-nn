#!/bin/bash
make clean
make

# Train model
./generate_points.x < generate_train.inp
./fit.x < points.dat

# Evaluate model on new set of points.
./generate_points.x < generate_eval.inp
./evaluate.x < points.dat > sal_evaluate

This is a MATLAB program, it contains 3 parts. 
1. a MATLAB program that uses a for loop to compute π with a fixed number of random points.
   Plot the computed value of π and its deviation from the true value as the number of points increases.
   Measure the execution time of your code for different point counts, and create a plot comparing the precision to the computational cost.

How to use it?
   montecarlo_pi_for_loop_version(50);   %Enter the number of random points here

2. a modified version of the program that uses a while loop to compute π to a specified level of precision
   (e.g., 2 significant figures, 3 significant figures, etc.).
   Record the number of iterations required to achieve each level of precision.
   Importantly, the method for determining precision should NOT rely on the true value of π.

How to use it?
   [pi2, n2, h2] = montecarlo_pi_while(2);    % target 2 significant figures
   [pi3, n3]    = montecarlo_pi_while(3);     % target 3 significant figures


3. Modify the code in (2) to be a function that includes all the following features:

• The function should take a user-defined level of precision as input.

• A graphical display should plot the random points as they are generated, 
  with points inside the circle plotted in a different color than those outside the circle.

• The final computed value of π, written out to the user-specified precision, 
  should be both displayed in the command window and printed on the plot.

• The computed value of π should be returned by the function.

How to use it?
[pi4, n4] = mc_pi_sigfig(4, 0.05, 5000, 200000); 

# HopfFibration

We include a graphical user interface in the programme. It consists of an overlay that visualizes the points on the Riemann sphere and numerous scrollbars and buttons to change the way we obtain the points on the sphere and to enable the visualization of d-sections. We also enable the user to explore different d-sections using rotational matrices and the Hopf flow.

The Riemann Sphere
The sphere in the top left corner visualizes the points on the Riemann Sphere that we choose. We colour them like the projected fibres, to make the connection visible. When you click on the sphere, it will start or stop rotating, so you can always get a good perspective at the points. 

Scrollbars and Buttons
We use the class HScrollbars (from the Processing Foundation, https://processing.org/examples/scrollbar.html) to set up the scrollbars for varying the different variables.

We will go through the scrollbars and buttons from top to bottom. In the top right corner, you find the scrollbars to change the way the points on the Riemann Sphere are obtained. Here, the functions \texttt{VaryTheta()}, \texttt{VaryPhi()} and \texttt{Spiral()} are covered, as discussed in 2.1. With a click on the button, you enable the function, and with the scrollbars, you can change the input angle. In the special case of \texttt{VaryTheta()}, there are two scrollbars, which means we can give two different input angles if we wish to. If you want to choose only one angle, you can click on one scrollbar and then hover over the second while you move your mouse to change the value. The second scrollbar will then follow your movement as well.

Below that, there are three buttons to enable the visualization of d-sections. The first one is the 1-section $\Sigma_N$, the second one is $\Sigma_N$ coloured in two different colours, and the third one is the annular 2-section. 

The three scrollbars tagged with $\gamma_i$, $i \in 1,2,3$ rotate the d-sections with the rotational matrices $M_i$, as discussed in 3.3. To enable a rotation, click on the button on the left side of the scrollbar. Then you can change the input angle.

On the bottom of the window, there are two more scrollbars. The first one is to let the grid flow with the Hopf flow. To enable it, click on the button. It can also be used additionally to a rotation. That means you can first rotate the d-section and then let this new d-section flow with the Hopf flow. 
The last scrollbar is used for changing the number of circles that are plotted.

To reset the rotations or flow, you can click on the three d-section buttons again.

Camera Modes
Using the 'UP' button on your keyboard, you can switch between two camera modes: The first one is static, and the second one is rotating your view with the horizontal movement of your mouse. 


This project is part of my bachelor thesis called "Global Surfaces of Section and the Hopf Fibration", Heidelberg University, 2021

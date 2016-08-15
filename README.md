# Function graphing FPGA

Team project developed on FPGA using VHDL: Function graphing. This project was done during a university course (Technology and organization of computer systems) and finished in March 2014. Comments, report and user guide are in Spanish.

The project consists in a display in which the functions to be plotted are introduced using the keyboard. The range of functions admitted are integer polynomials, logarithms, trigonometric functions or a linear combination of them. The functions are displayed in the optimal range. Additionally the system shows the value of the function's integral over the displayed domain. If the function diverges, the infinite symbol will show up. The scale of the graphic can be determined using the leds in the FPGA.

Xilinx ISE was employed to write the VHDL files and to synthesize the corresponding project.bit, which can be directly transferred to a suitable FPGA in order to operate the system. GuiaUtilizacion.pdf contains a brief description of what our hardware does and how it is used. DocumentoProyecto.pdf contains the technical details of the project. Some Matlab scripts used to automatize the addition of functions to the system are also included.

You can see a video of how the project works here: https://youtu.be/xBqoPvvWWQg

[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/xBqoPvvWWQg/0.jpg)](https://youtu.be/xBqoPvvWWQg)



## Authors

This project was developed by Ana María Martínez Gómez, Aitor Alonso Lorenzo and Víctor Adolfo Gallego Alcalá. There is some code that we used in our project that was not developed by us.  That code is (as it also is indicated in the author comment of the corresponding files): 

* The keyboard interaction module that was developed by Ali Diouri.
* The clock divisor was developed by our teacher Hortensia Mecha.
* The RAM file was initially developed by our teacher Márcos Sánchez-Élez and then modified by us.



## Licence

Code published under GNU GENERAL PUBLIC LICENSE v3 (see [LICENSE](LICENSE)).

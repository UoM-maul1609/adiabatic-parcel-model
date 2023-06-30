# Adiabatic Parcel Model / Calculator

Adiabatic Parcel Model is a Fortran90 code to perform a simple, but accurate adiabatic liquid water calculation.

# Table of contents
1. [Overview](#overview)
2. [Dependencies](#Dependencies)
3. [Folder structure](#Folder-Structure)
5. [Contributing](#Contributing)
6. [Code of Conduct](#Code-of-Conduct)

## Overview <a name="overview"></a>

It is useful to quickly calculate adiabatic liquid water content for comparison with research / cloud physics aircraft data. This can aid understanding and help with diagnosing faults with cloud probes in certain situations. For instance certain types of stratocumulus clouds are often close to having adiabatic liquid water mixing ratios, so it is useful to be able to calculate them given cloud base conditions.

Initial temperature, pressure, rh, height; final pressure; and a droplet number concentration and vertical spacing are entered as commandline arguments. 

The model then calculates the vapour mixing ratio and the pressure / temperature that this vapour mixing ratio would be equal to the saturation mixing ratio (assuming a dry adiabatic expansion). This is known as the lifting condensation level.

Then the pressure is integrated along a moist adiabat. The liquid water mixing ratio is calculated along the adiabat until the final pressure is reached.




## Dependencies <a name="Dependencies"></a>

Compiles using gfortran. The C-preprocessor may also be needed. Make, ar, and ranlib are also used - see Makefile.

If you would like to generate doxygen documentation you will need to install and run doxygen on the fortran.dxg file. You may also need an installation of latex.

## Folder structure <a name="Folder-Structure"></a>

The repository structure is now discussed. Most numerical functions are in the osnf directory. 

There are also two extra *.f90 files: main.f90, which contains the main program; and adiabatic.f90, which contains a module with helper functions.

Compile the code by typing 

```
make
```

at the command prompt. If it fails, check the makefile, it may need tailoring to your system.

As an example of how to run the code, type the following at the command line:

```
./adiabatic.exe 290. 100000. 80000. 0.7 0 100. 15
```

You should see 6 columns of data: the dry temperature (for reference); the actual adiabatic temperature; the pressure, the height, the liquid water mixing ratio and the average size of droplets (given 100 /cc drops).

If you would like to output to a file, you can always redirect stdout to a file:

```
./adiabatic.exe 290. 100000. 80000. 0.7 0 100. 15 > /tmp/text.txt
```

### Directory layout

    .                           
    ├── osnf                  	# some open source functions
    ├── Makefile         			# the make file
    ├── adiabatic.f90         	# module of functions
    ├── main.f90			         	# main program
    └── README.md
    

----------


## Contributing<a name="Contributing"></a>

Contributions to this simple project are more than welcome.  

Please use the issue tracker at https://github.com/UoM-maul1609/adiabatic-parcel-model/issues if you want to notify me of an issue or need support. If you want to contribute, please either create an issue or make a pull request. 

## Code of Conduct<a name="Code-of-Conduct"></a>

To be arranged.
# Geometry-aware Differentiable Obstacle Avoidance Framework for Robot Safety 
This repository contains the Python implementation of the framework proposed in our paper "Geometry-aware Differentiable Obstacle Avoidance Framework for Robot Safety". The following implementation was developed and tested on Ubuntu 20.04 using Python 3.8.

- Paper: [IEEE Robotics and Automation Letters (RA-L)](Link)
- Documentation: [Python Documentation](Link)
- Data: [Data used for comparative simulation studies](Link)

## Navigation
- [Dependencies](https://github.com/loUTSyd/differentiable-obstacle-avoidance?tab=readme-ov-file#dependencies)
- [Installation](https://github.com/loUTSyd/differentiable-obstacle-avoidance?tab=readme-ov-file#installation)
- [Reproducing paper results](https://github.com/loUTSyd/differentiable-obstacle-avoidance?tab=readme-ov-file#paper-experiments)
- [Citing this Repository](https://github.com/loUTSyd/differentiable-obstacle-avoidance?tab=readme-ov-file#citation)

## Dependencies
The dependencies in this project is generally handled by the pyproject.toml when the module is installed using pip. However, some libraries of interest which you may need to build the following libraries from source include:
- [Casadi](https://github.com/casadi/casadi) (Tested using V3.7.0): Symbolic framework for numeric optimization
- [IPOPT](https://github.com/coin-or/Ipopt) (Tested using V3.14.11): Software package for large-scale nonlinear optimization
- [HSL](https://www.hsl.rl.ac.uk/) (Tested using v2.2.5): A collection of state-of-the-art packages for large-scale scientific computation

This is often the case if you plan to use HSL linear solvers (eg ma27) or commercially available/custom non-linear optimisation solver (eg [SNOPT](https://ccom.ucsd.edu/~optimizers/solvers/snopt/)).

Please note that the paper implementation used the ma27 linear solver. If you would like to use mumps as the linear solver, you will need to change the (default) linear_solver option in the corresponding ipopt_cfg file inside tests/data/comparative_study_{1,2}. This may or may not change the results you obtain on your machine.

## Installation
- Clone the repository
```sh
git clone repo_link
```
### Build in local host
It is recommended that you use a virtual environment to avoid dependency conflicts. The module can be installed by running
```sh
pip install -e .
```
If you would also like to run the tests and obtain the results from the paper, you need to install optional dependencies by running
```sh
pip install -e .[comparative_studies]
```

### Build using docker
From the root repo directory, run
```sh
docker build -t cbf_diff_sq .
docker run -it cbf_diff_sq:latest
```



## Paper experiments
### Comparative study 1
The results was compared with Ruan S., et al. Their results can also be obtained [here](https://drive.google.com/drive/folders/17jSSC-EIhiSTqXSgfoEOs4R7mzKy1d1i?usp=sharing). See their [repo](https://github.com/ChirikjianLab/cfc-collision/tree/main) for more information about their work.

To run the tests, go to the root directory of this repository and run the following commands
```sh
cd tests/comparative_study_1/
python3.8 cfc_comparison.py
```

### Comparative study 2
To run this study, you will need to install the code from Dai B., et al. To learn more about their work and how to install the codebase, please refer to their [official paper website](https://differentiableoptimizationcbf.readthedocs.io/en/latest/). **This must be installed to successfully run the scaling factor method**.

To run the tests, go to the root directory of this repository and run the following commands
```sh
cd tests/comparative_study_2/
python3.8 generate_locations.py  # This will generate a file with random positions and orientations
python3.8 cbf_comparison --save # This will run the experiment and generate results using the proposed method
python3.8 cbf_comparison --save --julia # This will run the experiment and generate results using the scaling factor method
```
The script generate_locations.py is provided if you would like to generate the random poses that was used in the paper experiment yourself. If you would like to generate different poses, simply change the seed by passing the --np_seed argument when running the script. For instance,
```sh
python3.8 generate_locations.py np_seed 10 
```
The results for each method will be stored as a csv file in data/comparative_study_2/results

If you see the following error message
```commandline
cannot find /usr/lib/.../crtn.o: Too many open files
collect2: error: ld returned 1 exit status
```
You may need to run ```ulimit -n 1048576``` in terminal. This is because CasADI generates, compiles and open many temporary files which may hit the default OS limit.

## Citation
If you find this work useful in your work, please cite the paper using the following bibtex

```bibtex
@article{DifferentiableFernandez2025,
  author       = {Louis Fernandez and Sheila Sutjipto and Victor Hernandez and Marc Carmichael},
  title        = {Differentiable Collision Avoidance using Superquadric Representation},
  journal      = {{IEEE} Robotics and Automation Letters},
  year         = {2025},
  volume       = {},
  number       = {},
  pages        = {},
}
```
# 3D Object Reconstruction from Stereo Images using MATLAB

This repository contains MATLAB software developed as part of an academic course, specifically designed for reconstructing 3D objects from stereo images. The software utilizes the SIFT (Scale-Invariant Feature Transform) algorithm for point matching in conjunction with triangulation techniques to achieve accurate reconstruction.

## Overview

The software demonstrates its functionality through the reconstruction of 3D objects using sample stereo images captured at various historical landmarks. Visual results and outputs can be found in the `figures` directory. Additionally, users are encouraged to experiment with their own collection of images for further exploration and reconstruction.

## Getting Started

To reproduce the results or experiment with your own images, follow these steps:

1. Clone the Repository.
2. Run the Software by executing `test.m` in MATLAB to initiate the reconstruction process.
3. If you wish to use your own collection of images, maintain a similar structure to the existing image sets within the project directory. Ensure that your images are properly formatted and labeled to facilitate an effective reconstruction process.

## Directory Structure

- `data`: Contains the example image sets used in the project.
- `figures`: Contains visual results and outputs generated from the provided sample images.
- `src`: Holds the source code, including MATLAB scripts and functions used for the reconstruction process.
- `lib`: Contains the vlfeat library for the SIFT algorithm.
- `test.m`: Main script to run and initiate the reconstruction process.


# DCHWT-GF-WF: Guided Filter Multi-Exposure Fusion with Wiener-Enhanced Pixel Significance in DCHWT for Halo Artifact Suppression (MATLAB)

This repository contains the MATLAB implementation of the proposed method:

> **"A Guided Filter Multi-Exposure Fusion with Wiener-Enhanced Pixel Significance in DCHWT for Halo Artifact Suppression"**

The code implements a **multi-stage image fusion pipeline** for multi-exposure images:

1. **Guided filter-based preprocessing:**  
   Each input image is processed using an edge-preserving guided filter applied channel-wise. This step suppresses noise while maintaining structural details, improving robustness against illumination inconsistencies and preparing the images for multi-scale decomposition.

2. **DCHWT-based multi-scale fusion with Wiener-enhanced significance:**  
   The filtered images are decomposed using the Discrete Cosine Harmonic Wavelet Transform (DCHWT). High-frequency subbands are refined using Wiener filtering, and a multi-scale pixel significance measure is computed to guide fusion. Adaptive nonlinear weighting ensures effective preservation of salient structures while suppressing artifacts and noise.

The implementation targets **multi-exposure image fusion**, where differently exposed images are combined into a single image with enhanced contrast, detail preservation, and reduced artifacts. The framework is also applicable to related domains such as medical imaging, remote sensing, and underwater image enhancement.

---

## Repository Structure

- `main.m`  
  Main entry point.  
  - Loads input images (`Ia`, `Ib`)  
  - Applies guided filtering as preprocessing  
  - Performs DCHWT-based decomposition and fusion  
  - Reconstructs the fused image  
  - Calls `matrices_new.m` to compute quantitative image quality metrics  

- `dchwt.m`  
  Core implementation of the **Discrete Cosine Harmonic Wavelet Transform (DCHWT)**.  
  - Performs forward multi-level decomposition  
  - Applies frequency-domain detail enhancement  
  - Reinforces high-frequency components using gradient magnitude  
  - Supports inverse reconstruction  

- `fusion.m`  
  Core fusion strategy.  
  - Applies Wiener filtering on detail subbands  
  - Computes multi-scale pixel significance maps  
  - Uses Gaussian smoothing for stability  
  - Generates adaptive nonlinear weights for coefficient fusion  

- `sobel_fn.m`  
  Computes gradient information (horizontal and vertical) used in edge-based metric evaluation.

- `per_extn_im_fn.m`  
  Implements periodic image extension for boundary handling during local operations.

- `matrices_new.m`  
  Computes all quantitative image quality metrics used for evaluation, including:  
  - Statistical metrics (API, SD, AG)  
  - Information-theoretic metrics (Entropy, MIF)  
  - Correlation and spatial metrics (SF, correlation)  
  - Edge-based metrics (QABF, LABF, NABF)  

- `imhist_fn.m`, `joint_hist_fn.m`  
  Utility functions for computing histogram and joint histogram, used in entropy and mutual information calculations.

- `readme.md` (this file)  
  High-level description, usage instructions, and documentation for the repository.

---

## Requirements

- MATLAB  
- Image Processing Toolbox (for filtering, resizing, and image handling functions)

---

## How to Run

1. Clone or download this repository into a folder on your machine.  
2. Place input images in the `images` folder.
3. Add the folder (and its subfolders, if any) to the MATLAB path:
   ```matlab
   addpath(genpath('path_to_this_repo'));
   ```
4. Run the main script:
   ```matlab
   main
   ```
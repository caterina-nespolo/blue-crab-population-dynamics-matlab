# Blue Crab Population Dynamics - MATLAB

A MATLAB-based simulation and analysis framework for modelling the population dynamics of the blue crab (*Callinectes sapidus*) in response to environmental and biological drivers.

This project was developed as part of the MSc thesis "Dynamic Modelling and Simulation of Blue Crab (*Callinectes Sapidus*) Populations", University of Padova, 2024–2025, supervisor: prof. Mirco Rampazzo, co-supervisor: prof. Alberto Barausse.

## Overview

The blue crab (*Callinectes sapidus*) is an invasive species causing significant ecological and economic impact in Mediterranean coastal ecosystems. This project implements a two-compartment ODE model describing the temporal evolution of juvenile and adult female crab densities in the Chesapeake Bay (Maryland, USA), driven by water temperature, predation, fishing pressure, and density-dependent reproduction.

The framework includes:

- A mechanistic ODE model of juvenile and adult population dynamics
- Global sensitivity analysis via the Elementary Effects (Morris) method
- Multi-objective parameter calibration via genetic algorithm (NSGA-II)
- Visualization tools for model fit, calibration results, and sensitivity indices

## Repository Structure

```
blue-crab-population-dynamics-matlab/
│
├── outputs/
│   ├── calibration_out.mat           # Saved calibration results (Pareto front, optimal parameters)
│   └── sensitivity_analysis_out.mat  # Saved sensitivity analysis results (EE indices, confidence bounds)
│
├── processed_data/
│   ├── data.mat                      # Processed crab density data ready for modelling
│   └── temperature.mat               # Processed monthly temperature time series [°C]
│
├── raw_data/
│   ├── maryland_data.xlsx                                               # Observed crab density data (Maryland DNR)
│   └── tos.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc     # Sea surface temperature reanalysis (1993–2023)
│
├── src/
│   ├── functions/
│   │   ├── make_X_yearly.m            # Aggregates simulation output to yearly densities
│   │   ├── model_eval.m               # Evaluates the model and computes objective functions
│   │   ├── pack_params.m              # Packs parameter vectors
│   │   ├── run_calibration.m          # NSGA-II multi-objective calibration
│   │   ├── run_sensitivity_analysis.m # Elementary Effects sensitivity analysis
│   │   └── simulate_and_compare.m     # Runs simulation and compares to observations
│   │
│   ├── model/
│   │   ├── crab_model.m               # ODE system: crab population dynamics
│   │   └── crab_model_ode.m           # ODE function handle for solver integration
│   │
│   ├── SAFE_sensitivity_analysis/
│   │   ├── EET/
│   │   │   ├── EET_convergence.m
│   │   │   ├── EET_indices.m
│   │   │   └── EET_plot.m
│   │   ├── sampling/
│   │   │   ├── AAT_sampling.m
│   │   │   ├── lhcube.m
│   │   │   ├── Morris_sampling.m
│   │   │   └── OAT_sampling.m
│   │   └── visualization/
│   │       ├── Andres_plots.m
│   │       ├── boxplot1.m
│   │       ├── boxplot2.m
│   │       ├── parcoor.m
│   │       ├── plot_cdf.m
│   │       ├── plot_convergence.m
│   │       ├── plot_pdf.m
│   │       ├── scatter_plots.m
│   │       ├── scatter_plots_col.m
│   │       ├── scatter_plots_interaction.m
│   │       └── stackedbar.m
│   │
│   └── visualization/
│       ├── barplot_results.m
│       ├── plot_calibration.m
│       ├── plot_results.m
│       └── plot_sensitivity_analysis.m
│
├── data_processing.m                  # Data loading and preprocessing
├── main.mlx                           # Main pipeline: sensitivity analysis, calibration, visualization
└── README.md
```

## Model Description

The model tracks two state variables:

- **J** — juvenile crab density [#crabs/1000m²]
- **A** — adult female crab density [#crabs/1000m²]

The ODE system includes the following biological processes:

| Process | Description |
|---|---|
| Recruitment | Temperature-dependent Ricker model |
| Predation | Type-II functional response (juveniles) |
| Maturation | Temperature-dependent juvenile-to-adult transition |
| Fishing mortality | Linear mortality on adults |
| Natural mortality | Constant adult mortality rate |

Sensitivity analysis identifies the most influential parameters using the Elementary Effects method with Latin Hypercube Sampling (r=1000, radial design) and bootstrapped confidence intervals (Nboot=100), using the [SAFE Toolbox](https://github.com/SAFEtoolbox/SAFE-matlab).

Calibration minimizes the mean squared error between simulated and observed yearly densities (December–March window) jointly on juveniles and adults, using NSGA-II with a population of 100 individuals over 200 generations.

## Requirements

- MATLAB R2021b or later
- [Global Optimization Toolbox](https://www.mathworks.com/products/global-optimization.html) (for NSGA-II via `gamultiobj`)
- [SAFE Toolbox](https://github.com/SAFEtoolbox/SAFE-matlab) (included in `src/SAFE_sensitivity_analysis/`)

## Usage

To get started, open and run `main.mlx` directly — processed data is already available in `processed_data/` and no preprocessing step is required.

### 1. Data preprocessing *(optional — only needed to reprocess raw data)*

```matlab
run('data_processing.m')
```

Loads raw input data from `raw_data/`, processes the temperature time series and observed crab densities, and saves the processed inputs to `processed_data/`. Skip this step if you are using the data files already provided.

### 2. Main pipeline

Open `main.mlx` in MATLAB and run all sections. The pipeline covers:

1. Run sensitivity analysis to identify influential parameters
2. Run NSGA-II calibration on the selected parameters
3. Evaluate and visualize model fit on training and validation sets

Results are saved to `outputs/` as `.mat` files and can be reloaded for visualization without re-running the full pipeline.

To run calibration and sensitivity analysis independently:

```matlab
% Sensitivity analysis
results_sens = run_sensitivity_analysis(time_ode, T_ode, X0, juveniles, adult_fems, thresh);
save('outputs/sensitivity_analysis_out.mat', 'results_sens');

% Calibration
results_cal = run_calibration(time_ode_train, X0_train, juveniles_train, adult_fems_train, T_ode_train, selected_parameters_indices);
save('outputs/calibration_out.mat', 'results_cal');
```

## License

This project is released for academic and research purposes.

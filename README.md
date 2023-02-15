# IntermittentDemand

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://akai01.github.io/IntermittentDemand.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://akai01.github.io/IntermittentDemand.jl/dev/)
[![Build Status](https://github.com/akai01/IntermittentDemand.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/akai01/IntermittentDemand.jl/actions/workflows/CI.yml?query=branch%3Amain)


<img src="./.github/images/figure-markdown_strict/under_construction.png" width="60%" />

“IntermittentDemand” is a Julia package that provides functions for
forecasting and analyzing intermittent time series, which are time
series with long periods of zeros or near-zeros, and occasional non-zero
observations.

The package currently includes functions for forecasting intermittent
time series using several methods, including Croston’s method,
Syntetos-Boylan Approximation 1 and 2, Shale-Boylan-Johnston method, and
more. Additionally, the package provides API for piloting the
implemented methods.

To install “IntermittentDemand”, you can clone the repository
directly from GitHub. Open a Julia REPL and enter the following
commands:

    ] # enter package mode
    add https://github.com/Akai01/IntermittentDemand.jl.git

After the package is added, you can import the necessary functions into
your Julia script or notebook and start using them.

If you have any feedback or suggestions for the package, or if you
encounter any issues while using it, please feel free to open an issue
on the package’s GitHub repository. We welcome contributions and
feedback from the community to improve this package.

# Examples

## Data

    data = [6, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0,
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 
    0, 0, 0, 0, 0];

## Forecasting using Croston method

    fc = crost(data = data, h = 12, w = missing, init= "mean", nop = 2, method = "croston", cost = "mar", init_opt = true, na_rm = false);

## Plot

    using Plots;
    plot(fc)

<img src="./.github/images/figure-markdown_strict/pressure3-J1.png" width="60%" />

## Forecasting using Syntetos-Boylan approximation method

    fc = crost(data = data, h = 12, w = missing, init= "mean", nop = 2, method = "sba", cost = "mar", init_opt = true, na_rm = false);

## Plot

    using Plots;
    plot(fc)

<img src="./.github/images/figure-markdown_strict/pressure5-J1.png" width="60%" />

## Forecasting using Shale-Boylan-Johnston method

    fc = crost(data = data, h = 12, w = missing, init= "mean", nop = 2, method = "sbj", cost = "mar", init_opt = true, na_rm = false);

## Plot

    using Plots;
    plot(fc)

<img src="./.github/images/figure-markdown_strict/pressure7-J1.png" width="60%" />

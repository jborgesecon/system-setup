# home-manager/borges/R.nix
{ config, pkgs, ... }:

let
  myR = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      # Development and Language Support
      dotenv
      here
      languageserver
      rmarkdown

      # LaTeX and styling
      texreg
      kableExtra
      knitr
      stargazer
      svglite
      # xtable

      # Data Manipulation and Processing
      DBI
      dplyr
      openxlsx
      tidyverse
      rlang

      # Database Connectivity
      RPostgres

      # Econometric and Financial Analysis
      aod
      plm
      quantmod
      tidyquant
      timetk
      vars
      yfR
      MSGARCH

      # Time Series Analysis
      forecast
      rugarch
      Rsolnp
      truncnorm
      tseries
      urca
      xts
      zoo
      FinTS

      # Statistical Distributions and Analysis
      SkewHyperbolic
      DistributionUtils
      GeneralizedHyperbolic
      chron
      ks
      FNN
      kernlab
      mclust
      multicool
      pracma
      nloptr
      spd

      # Visualization and Plotting
      animation
      DT
      gganimate
      ggcorrplot
      ggplot2
      magick
      patchwork
      scales
      shiny
      shinythemes
      shinyjs
    ];
  };

in
{
  home.packages = with pkgs; [
    myR  # Only install the wrapped R with packages, not base R
  ];
}

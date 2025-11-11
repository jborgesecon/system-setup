# home-manager/borges/R.nix
{ config, pkgs, ... }:

let
  myR = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      # Development and Language Support
      dotenv
      here
      languageserver

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

      # Time Series Analysis
      forecast
      rugarch
      Rsolnp
      truncnorm
      tseries
      urca
      xts
      zoo

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

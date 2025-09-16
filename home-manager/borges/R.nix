# home-manager/borges/R.nix
{ config, pkgs, ... }:


let
  myR = pkgs.rWrapper.override {
  packages = with pkgs.rPackages; [
    # Development and Language Support
    dotenv
    here
    languageserver

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
    tseries

    # Visualization and Plotting
    animation
    DT
    gganimate
    ggcorrplot
    ggplot2
    magick
    scales
    shiny
    shinythemes
    shinyjs
  ];
};

in
{
  home.packages = with pkgs; [
    R
    myR
  ];
}

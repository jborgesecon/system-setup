# home-manager/borges/R.nix
{ config, pkgs, ... }:


let
  myR = pkgs.rWrapper.override {
  packages = with pkgs.rPackages; [
    languageserver
    dplyr
    ggplot2
    plm
    tidyverse
    quantmod
    timetk
    scales
    tidyquant
    # BatchGetSymbols
    yfR
    ggcorrplot
    vars
    aod
    openxlsx
  ];
};

in
{
  home.packages = with pkgs; [
    R
    myR
  ];
}

{ config, pkgs, ... }:

let
  # --- Manual Python Package Selection ---
  # Define commonly used Python packages for scientific computing, data science, and development
  
  # Core scientific computing and data science packages
  scientificPackages = with pkgs.python3Packages; [
    numpy
    scipy
    pandas
    matplotlib
    seaborn
    plotly
    scikit-learn
    statsmodels
    sympy
    manim  # May have compatibility issues with Python 3.13, can be installed via pip if needed
    islpy
  ];

  # Machine learning and AI packages
  # Note: TensorFlow is currently not supported with Python 3.13 in nixpkgs
  # Use PyTorch as the main deep learning framework, or install TensorFlow via pip if needed
  pyTensorFlow = with pkgs.python313Packages; [
    tensorflow-bin  # Currently unsupported with Python 3.13
  ];

  mlPackages = with pkgs.python3Packages; [

    torch
    torchvision
    scikit-image
    opencv4
    pillow
    imageio
  ];

  # Jupyter and notebook packages
  jupyterPackages = with pkgs.python3Packages; [
    jupyter
    jupyterlab
    notebook
    ipython
    ipykernel
    ipywidgets
    nbconvert
    nbformat
  ];

  # Web development and APIs
  webPackages = with pkgs.python3Packages; [
    requests
    fastapi
    flask
    django
    beautifulsoup4
    selenium
    scrapy
    httpx
    aiohttp
  ];

  # Database and storage packages
  databasePackages = with pkgs.python3Packages; [
    sqlalchemy
    psycopg2
    pymongo
    redis
  ];

  # Development and testing tools
  devPackages = with pkgs.python3Packages; [
    pytest
    black
    flake8
    mypy
    isort
    autopep8
    pylint
  ];

  # Utility and miscellaneous packages
  utilityPackages = with pkgs.python3Packages; [
    click
    rich
    typer
    pydantic
    python-dotenv
    configparser
    dateutil
    pytz
    tqdm
    loguru
  ];

  # Create the Python environment with all selected packages
  pythonEnv = pkgs.python3.withPackages (ps: with ps; 
    scientificPackages ++
    mlPackages ++
    jupyterPackages ++
    webPackages ++
    databasePackages ++
    devPackages ++
    utilityPackages
  );

  # Get the path to the C++ standard library (same as shell.nix)
  libstdcppPath = pkgs.stdenv.cc.cc.lib + "/lib";

in
{
  # Python environment with all packages
  home.packages = [
    pythonEnv
    
    # Additional Python tools that aren't Python packages
    # Note: python3Full is not needed since pythonEnv already provides a complete Python
    pkgs.sqlite
    pkgs.pipx  # For installing Python applications in isolated environments
    pkgs.poetry  # Python dependency management
    pkgs.pyenv  # Python version management (if needed alongside Nix)
  ];

  # Environment variables for Python development
  home.sessionVariables = {
    # Add C++ library path for packages with native extensions
    LD_LIBRARY_PATH = "${libstdcppPath}:$LD_LIBRARY_PATH";
    
    # Jupyter configuration
    JUPYTER_CONFIG_DIR = "$HOME/.config/jupyter";
    JUPYTER_DATA_DIR = "$HOME/.local/share/jupyter";
  };

  # Create Jupyter configuration directory and basic config
  home.file.".config/jupyter/jupyter_lab_config.py".text = ''
    # Jupyter Lab configuration
    c.ServerApp.ip = '127.0.0.1'
    c.ServerApp.open_browser = True
    c.ServerApp.port = 8888
    c.ServerApp.token = ""
    c.ServerApp.password = ""
    
    # Enable extensions
    c.LabApp.collaborative = True
  '';

  # Python development aliases (if using fish shell)
  programs.fish.shellAliases = {
    # Python shortcuts
    py = "python";
    py3 = "python3";
    ipy = "ipython";
    
    # Jupyter shortcuts
    jlab = "jupyter lab";
    jnb = "jupyter notebook";
    
    
    # Development tools
    pyformat = "black . && isort .";
    pylint-all = "find . -name '*.py' | xargs pylint";
    pytest-cov = "pytest --cov=. --cov-report=html";
    
  };

  # Note: Some packages like TensorFlow and Manim may not be available in nixpkgs
  # for newer Python versions. You can install them using pip:
  # - pip install --user tensorflow
  # - pip install --user manim
  # The --user flag installs packages to your user directory to avoid conflicts
}
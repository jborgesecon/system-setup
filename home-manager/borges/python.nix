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
    manim
    islpy
  ];

  # Machine learning and AI packages
  mlPackages = with pkgs.python3Packages; [
    tensorflow
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
    sqlite3
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
    pre-commit
    tox
    poetry
    pip-tools
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
    pkgs.python3Full
    pkgs.pipx  # For installing Python applications in isolated environments
    pkgs.poetry  # Python dependency management
    pkgs.pyenv  # Python version management (if needed alongside Nix)
  ];

  # Environment variables for Python development
  home.sessionVariables = {
    # Add C++ library path for packages with native extensions
    LD_LIBRARY_PATH = "${libstdcppPath}:$LD_LIBRARY_PATH";
    
    # Python-specific environment variables
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";
    PIP_USER = "1";  # Install pip packages to user directory by default
    
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
    c.ServerApp.token = ''
    c.ServerApp.password = ''
    
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
    
    # Package management
    pip-upgrade = "pip list --outdated --format=freeze | grep -v '^\\-e' | cut -d = -f 1 | xargs -n1 pip install -U";
    
    # Development tools
    pyformat = "black . && isort .";
    pylint-all = "find . -name '*.py' | xargs pylint";
    pytest-cov = "pytest --cov=. --cov-report=html";
  };
}
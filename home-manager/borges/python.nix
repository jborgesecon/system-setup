# ./home-manager/borges/python.nix
{ config, pkgs, ... }:

let
  # --- Manual Python Package Selection ---
  # Define commonly used Python packages for scientific computing, data science, and development
  
  # Core scientific computing and data science packages
  scientificPackages = with pkgs.python312Packages; [
    numpy
    scipy
    pandas
    openpyxl
    matplotlib
    seaborn
    plotly
    scikit-learn
    statsmodels
    sympy
    manim  # Should work better with Python 3.12
    islpy  # Temporarily disabled due to build issues with CMake not finding isl source files
  ];

  # Machine learning and AI packages
  # TensorFlow should be available with Python 3.12
  pyTensorFlow = with pkgs.python312Packages; [
    tensorflow
    protobuf
  ];

  mlPackages = with pkgs.python312Packages; [
    imageio
    lightgbm
    opencv4
    optuna
    pillow
    scikit-image
    torch
    torchvision
  ];

  # Jupyter and notebook packages
  jupyterPackages = with pkgs.python312Packages; [
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
  webPackages = with pkgs.python312Packages; [
    requests
    fastapi
    flask
    django
    beautifulsoup4
    selenium
    scrapy
    streamlit
    httpx
    aiohttp
  ];

  # Database and storage packages
  databasePackages = with pkgs.python312Packages; [
    sqlalchemy
    psycopg2
    pymongo
    redis
  ];

  # Development and testing tools
  devPackages = with pkgs.python312Packages; [
    pytest
    black
    flake8
    mypy
    isort
    autopep8
    pylint
  ];

  # Utility and miscellaneous packages
  utilityPackages = with pkgs.python312Packages; [
    click
    rich
    typer
    pdf2image
    pydantic
    pytesseract
    python-dotenv
    configparser
    dateutil
    pytz
    tqdm
    loguru
  ];

  # Create the Python environment with all selected packages
  pythonEnv = pkgs.python312.withPackages (ps: with ps; 
    scientificPackages ++
    pyTensorFlow ++
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

  # Note: Using Python 3.12 for better compatibility with TensorFlow and other packages
  # If you need packages not available in nixpkgs for Python 3.12, you can install them using pip:
  # - pip install --user package_name
  # The --user flag installs packages to your user directory to avoid conflicts
}
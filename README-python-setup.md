# Python Development Environment Configuration

## Overview
The `python.nix` file provides a comprehensive Python development environment inspired by the structure of `shell.nix`, with manually curated packages for scientific computing, data science, web development, and general Python development.

## Package Categories

### 🔬 Scientific Computing & Data Science
- **numpy, scipy** - Numerical computing fundamentals
- **pandas** - Data manipulation and analysis
- **matplotlib, seaborn, plotly** - Data visualization
- **scikit-learn, statsmodels** - Machine learning and statistics
- **sympy** - Symbolic mathematics
- **islpy** - Integer set library Python bindings for polyhedral computations
- **Note**: Manim may have compatibility issues with Python 3.13. Use `install-manim` alias to install via pip if needed.

### 🤖 Machine Learning & AI
- **torch, torchvision** - PyTorch deep learning framework
- **scikit-image, opencv4** - Computer vision
- **pillow, imageio** - Image processing
- **Note**: TensorFlow is currently not available for Python 3.13 in nixpkgs. Use `install-tensorflow` alias to install via pip if needed.

### 📓 Jupyter & Interactive Development
- **jupyter, jupyterlab, notebook** - Interactive notebooks
- **ipython, ipykernel, ipywidgets** - Enhanced Python REPL
- **nbconvert, nbformat** - Notebook utilities

### 🌐 Web Development & APIs
- **requests, httpx, aiohttp** - HTTP clients
- **fastapi, flask, django** - Web frameworks
- **beautifulsoup4, selenium, scrapy** - Web scraping

### 🗄️ Database & Storage
- **sqlalchemy** - SQL toolkit and ORM
- **psycopg2, pymongo, redis** - Database drivers
- **sqlite3** - Lightweight database

### 🛠️ Development & Testing Tools
- **pytest** - Testing framework
- **black, flake8, mypy, isort** - Code formatting and linting
- **autopep8, pylint** - Additional code quality tools
- **pre-commit, tox** - Development workflow tools
- **poetry, pip-tools** - Dependency management

### 🔧 Utilities
- **click, typer** - CLI frameworks
- **rich** - Rich text and beautiful formatting
- **pydantic** - Data validation
- **python-dotenv** - Environment variable management
- **tqdm, loguru** - Progress bars and logging

## Environment Configuration

### Environment Variables
- `LD_LIBRARY_PATH` - Includes C++ standard library for native extensions
- `PYTHONPATH` - User site-packages directory
- `PIP_USER` - Install pip packages to user directory by default
- `JUPYTER_CONFIG_DIR` - Jupyter configuration directory
- `JUPYTER_DATA_DIR` - Jupyter data directory

### Jupyter Lab Configuration
Automatically creates `~/.config/jupyter/jupyter_lab_config.py` with:
- Local server binding (127.0.0.1:8888)
- Auto-open browser
- Disabled token/password for local development
- Collaborative features enabled

### Shell Aliases (Fish Shell)
- `py`, `py3` - Python shortcuts
- `ipy` - IPython
- `jlab` - Jupyter Lab
- `jnb` - Jupyter Notebook
- `pip-upgrade` - Upgrade all outdated packages
- `pyformat` - Format code with black and isort
- `pylint-all` - Lint all Python files
- `pytest-cov` - Run tests with coverage
- `install-tensorflow` - Install TensorFlow via pip (for Python 3.13 compatibility)
- `install-manim` - Install Manim via pip (for Python 3.13 compatibility)

## Additional Tools
- **python3Full** - Complete Python installation
- **pipx** - Install Python applications in isolated environments
- **poetry** - Modern dependency management
- **pyenv** - Python version management (complementary to Nix)

## Usage

### After Installation
1. Rebuild home-manager configuration:
   ```bash
   home-manager switch --flake .#borges
   ```

2. Verify Python environment:
   ```bash
   python -c "import numpy, pandas, matplotlib; print('All packages imported successfully!')"
   ```

3. Start Jupyter Lab:
   ```bash
   jlab
   ```

### Managing Additional Packages
While this configuration provides a comprehensive set of packages, you can:
1. Add packages to the appropriate category in `python.nix`
2. Use `pipx` for standalone applications
3. Use `poetry` or virtual environments for project-specific dependencies

## Python 3.13 Compatibility Notes

Some packages may not yet be available in nixpkgs for Python 3.13:

### Not Available in Nixpkgs (Install via pip)
- **TensorFlow**: Use `install-tensorflow` alias or `pip install --user tensorflow`
- **Manim**: Use `install-manim` alias or `pip install --user manim`

### Why Use pip with --user?
The `--user` flag installs packages to your user directory (`~/.local/lib/python3.13/site-packages`), avoiding conflicts with the Nix-managed Python environment while still making packages available in your PATH.

### Alternative Approaches
1. **Virtual Environments**: Use `python -m venv` for project isolation
2. **Poetry**: Use `poetry` for dependency management
3. **Pipx**: Use `pipx install package` for standalone applications

### Managing Additional Packages
While this configuration provides a comprehensive set of packages, you can:
1. Add packages to the appropriate category in `python.nix`
2. Use `pipx` for standalone applications
3. Use `poetry` or virtual environments for project-specific dependencies

### Integration with shell.nix
This configuration is compatible with your existing `shell.nix` setup:
- Both use the same C++ library path configuration
- Scientific computing dependencies are available system-wide
- No conflicts between environments

## Customization
To customize the Python environment:
1. Edit the package lists in `python.nix`
2. Modify environment variables as needed
3. Update Jupyter configuration
4. Add or modify shell aliases

The modular structure makes it easy to add/remove package categories or adjust configurations based on your specific needs.

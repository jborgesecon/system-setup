1. On Fedora, the bspm package is available as R-CoprManager, and enabled by default:

$ dnf --version | grep -q dnf5 || sudo dnf install 'dnf-command(copr)'
$ sudo dnf copr enable iucar/cran
$ sudo dnf install R-CoprManager

note: more on: https://cran.r-project.org/web/packages/bspm/readme/README.html
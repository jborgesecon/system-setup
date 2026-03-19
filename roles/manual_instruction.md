## Neovim Setup (for C/C++)

Simply following the tutorial at: https://www.lazyvim.org/installation

Make a backup of your current Neovim files:

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

Clone the starter

git clone https://github.com/LazyVim/starter ~/.config/nvim

Remove the .git folder, so you can add it to your own repo later

rm -rf ~/.config/nvim/.git

Start Neovim!

nvim

Refer to the comments in the files on how to customize LazyVim.

tip
It is recommended to run :LazyHealth after installation. This will load all plugins and check if everything is working correctly.
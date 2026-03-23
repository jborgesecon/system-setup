return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        r_language_server = {
          -- Tell LazyVim NOT to use Mason for this specific server
          mason = false,
          -- Point lspconfig directly to your system's R installation
          cmd = { "R", "--slave", "-e", "languageserver::run()" },
        },
      },
    },
  },
}

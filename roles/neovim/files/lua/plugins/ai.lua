return {
  -- 1. MCPHub: Manages your MCP servers
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        port = 3000,
        -- Point this to the JSON file we created in Step 1
        config_path = vim.fn.expand("~/.config/nvim/mcpservers.json"),
      })
    end,
  },

  -- 2. CodeCompanion: The AI Chat and orchestration interface
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim", -- Crucial: Ensures MCPHub loads first and injects tools
    },
    opts = {
      strategies = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
      },
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              -- Pointing to your mapped Fedora Ollama container port
              url = "http://localhost:11434",
            },
            schema = {
              model = {
                -- Make sure you have pulled this model in your Ollama container!
                default = "qwen2.5-coder:7b",
              },
            },
          })
        end,
      },
    },
    keys = {
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
    },
  },
}

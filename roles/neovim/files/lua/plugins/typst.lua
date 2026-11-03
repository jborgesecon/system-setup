return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = {},
    build = function()
      require("typst-preview").update()
    end,
  },
}


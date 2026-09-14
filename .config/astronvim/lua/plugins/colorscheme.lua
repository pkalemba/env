-- Gruvbox everywhere: tmux, starship, ghostty and VSCodium all use it, and
-- nvim was the only holdout on astrodark.
--
-- The plugin is declared directly rather than via an astrocommunity module so
-- the spec does not depend on that repo's module naming.

---@type LazySpec
return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = { contrast = "soft" }, -- matches VSCodium's "Gruvbox Dark Soft"
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = { colorscheme = "gruvbox" },
  },
}

return {
  colorscheme = "catppuccin",
  lsp = {
    formatting = {
      format_on_save = false, -- enable or disable automatic formatting on save
    },
  },
  plugins = {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
      "goolord/alpha-nvim",
      opts = function()
          local dashboard = require "alpha.themes.dashboard"

          require("alpha.term")
          local terminal = {
            type = "terminal",
            command = " ~/.config/nvim/lua/user/thisisfine.sh",
            width = 46,
            height = 25,
            opts = {
              redraw = true,
              window_config = {}
            }
          }
          dashboard.section.terminal = terminal
          dashboard.section.header.opts.hl = "DashboardHeader"
          dashboard.section.footer.opts.hl = "DashboardFooter"

          local button, get_icon = require("astronvim.utils").alpha_button, require("astronvim.utils").get_icon
          dashboard.section.buttons.val = {
            button("LDR n  ", get_icon("FileNew", 2, true) .. "New File  "),
            button("LDR f f", get_icon("Search", 2, true) .. "Find File  "),
            button("LDR f o", get_icon("DefaultFile", 2, true) .. "Recents  "),
            button("LDR f w", get_icon("WordFile", 2, true) .. "Find Word  "),
            button("LDR f '", get_icon("Bookmarks", 2, true) .. "Bookmarks  "),
            button("LDR S l", get_icon("Refresh", 2, true) .. "Last Session  "),
          }
          dashboard.config.layout = {
            -- { type = "padding", val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) } },
            dashboard.section.terminal,
            -- dashboard.section.header,
            { type = "padding", val = 5 },
            dashboard.section.buttons,
            { type = "padding", val = 3 },
            dashboard.section.footer,
          }
          dashboard.config.opts.noautocmd = true
          return dashboard
        end,
      config = require "plugins.configs.alpha",
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      config = function(plugin, opts)
        require("plugins.neo-tree")
        require("neo-tree").setup({
          filesystem = {
            filtered_items = {
              hide_dotfiles = false,
              hide_gitignored = false,
            }
          }
        })
      end,
    },
    {
      "sainnhe/gruvbox-material",
      enabled = true,
      priority = 1000,
      config = function()
        vim.g.gruvbox_material_transparent_background = 0
        vim.g.gruvbox_material_foreground = "mix"
        vim.g.gruvbox_material_background = "hard" -- soft, medium, hard
        vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
        vim.g.gruvbox_material_float_style = "bright" -- Background of floating windows
        vim.g.gruvbox_material_statusline_style = "material"
        vim.g.gruvbox_material_cursor = "auto"
      end,
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {  -- automatically install lsp
          "pyright",
          "ansiblels",
          "bashls",
          "docker_compose_language_service",
          "yamlls",
          "terraformls",
          "gopls",
          "jsonls",
          "dockerls",
        },
      },
    },
  },
  
  options = {
    opt = {
      scrolloff = 10
    } 
  },
  mappings = {
    n = {
      ["<C-`>"] = { "<cmd>ToggleTerm size=20 direction=horizontal<cr>", desc = "Toggle terminal" },
      ["<leader>tl"] = { "<cmd>ToggleTermSendCurrentLine<cr>", desc = "ToggleTerm execute current line" },
      ["<leader>um"] = { "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
    },
    v = {
      ["<leader>te"] = { "<cmd>ToggleTermSendVisualSelection<cr>", desc = "ToggleTerm execute selection" },
    },
  },
  polish = function()
    local function yaml_ft(path, bufnr)
      -- get content of buffer as string
      local content = vim.filetype.getlines(bufnr)
      if type(content) == "table" then content = table.concat(content, "\n") end

      -- check if file is in roles, tasks, or handlers folder
      local path_regex = vim.regex "(tasks\\|roles\\|handlers)/"
      if path_regex and path_regex:match_str(path) then return "yaml.ansible" end
      -- check for known ansible playbook text and if found, return yaml.ansible
      local regex = vim.regex "hosts:\\|tasks:"
      if regex and regex:match_str(content) then return "yaml.ansible" end
      -- check for known docker-compose text and of found, return yaml.docker-compose
      local regex = vim.regex "version:\\|services:"
      if regex and regex:match_str(content) then return "yaml.docker-compose" end
      -- return yaml if nothing else
      return "yaml"
    end

    vim.filetype.add {
      extension = {
        yml = yaml_ft,
        yaml = yaml_ft,
      },
    }
  end,
}

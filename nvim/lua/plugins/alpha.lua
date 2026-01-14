return {
  'goolord/alpha-nvim',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Header - Cat ASCII art
    dashboard.section.header.val = {
    -- [[                                                                             ]],
    -- [[ 888b      88                                        88                      ]],
    -- [[ 8888b     88                                        ""                      ]],
    -- [[ 88 `8b    88                                                                ]],
    -- [[ 88  `8b   88   ,adPPYba,   ,adPPYba,   8b       d8  88  88,dPYba,,adPYba,   ]],
    -- [[ 88   `8b  88  a8P_____88  a8"     "8a  `8b     d8'  88  88P'   "88"    "8a  ]],
    -- [[ 88    `8b 88  8PP"""""""  8b       d8   `8b   d8'   88  88      88      88  ]],
    -- [[ 88     `8888  "8b,   ,aa  "8a,   ,a8"    `8b,d8'    88  88      88      88  ]],
    -- [[ 88      `888   `"Ybbd8"'   `"YbbdP"'       "8"      88  88      88      88  ]],
    -- [[                                                                             ]],
    [[                                                   ]],
    [[888888ba                             oo            ]],
    [[88    `8b                                          ]],
    [[88     88 .d8888b. .d8888b. dP   .dP dP 88d8b.d8b. ]],
    [[88     88 88ooood8 88'  `88 88   d8' 88 88'`88'`88 ]],
    [[88     88 88.  ... 88.  .88 88 .88'  88 88  88  88 ]],
    [[dP     dP `88888P' `88888P' 8888P'   dP dP  dP  dP ]],
    [[                                                   ]],

    -- [[                                                                       ]],
    -- [[    ░███    ░██                                  ░██                   ]],
    -- [[    ░████   ░██                                                        ]],
    -- [[    ░██░██  ░██  ░███████   ░███████  ░██    ░██ ░██░█████████████     ]],
    -- [[    ░██ ░██ ░██ ░██    ░██ ░██    ░██ ░██    ░██ ░██░██   ░██   ░██    ]],
    -- [[    ░██  ░██░██ ░█████████ ░██    ░██  ░██  ░██  ░██░██   ░██   ░██    ]],
    -- [[    ░██   ░████ ░██        ░██    ░██   ░██░██   ░██░██   ░██   ░██    ]],
    -- [[    ░██    ░███  ░███████   ░███████     ░███    ░██░██   ░██   ░██    ]],
    -- [[                                                                       ]],
    -- [[                                                                       ]],
    -- [[                   oo                     ]],
    -- [[                                         ]],
    -- [[dP    dP d888888b dP 88d8b.d8b. 88d888b. ]],
    -- [[88    88    .d8P' 88 88'`88'`88 88'  `88 ]],
    -- [[88.  .88  .Y8P    88 88  88  88 88.  .88 ]],
    -- [[`88888P' d888888P dP dP  dP  dP 88Y888P' ]],
    -- [[                                88       ]],
    -- [[                                dP       ]],
    }
    

    -- Custom buttons
    dashboard.section.buttons.val = {
      dashboard.button('e', '  New file', '<cmd>ene<CR>'),
      dashboard.button('f', '  Find file', '<cmd>Telescope find_files<CR>'),
      dashboard.button('r', '  Recent files', '<cmd>Telescope oldfiles<CR>'),
      dashboard.button('p', '  Projects', '<cmd>Telescope projects<CR>'),
      dashboard.button('l', '󰒲  Lazy', '<cmd>Lazy<CR>'),
      dashboard.button('s', '󰦨  Restore session', '<cmd>lua require("persistence").load()<CR>'),
      dashboard.button('q', '󰿅  Quit', '<cmd>qa<CR>'),
    }

    dashboard.section.footer.val = {"uzimp",""}

    -- Set up alpha
    alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		-- Set custom background and disable folding for Alpha
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.opt_local.foldenable = false
				-- Apply the custom AlphaBackground highlight to the window's Normal group
				vim.opt_local.winhl = "Normal:AlphaBackground"
			end,
		})
  end,
}

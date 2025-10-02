local machine = require("config.machine")

return {
	-- {"folke/lazy.nvim"},
	{
		'marko-cerovac/material.nvim',
		priority=1000,
		lazy=false,
		config = function()
			vim.g.material_style="lighter"
			vim.cmd('colorscheme material')
		end,
	},
	{"numToStr/Comment.nvim"},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
			})
		end
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup ({
				view = {
					number=true,
					relativenumber=true,
				},
				renderer = {
					root_folder_label = ":t",
				},
				sync_root_with_cwd = false,
				update_focused_file = {
					enable = true,
				},
				git = {
					enable = true,
					ignore = false,
				}
			})
		end,
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'nvim-lua/plenary.nvim',
		},
		config = function() 
			require("bufferline").setup {
				options = {
					-- mode = "buffers",
					numbers = "ordinal",
					offsets = {
						{
							filetype = "NvimTree",
							text = "NvimTree",
							separator = true,
							text_align = "left",
						}
					},
					show_buffer_icons = false,
					show_buffer_close_icons = true,
					show_close_icon = false,
					always_show_bufferline = true,
				}
			}
		end,

	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'},
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = { "c", "cpp", "lua", "python", "go" },
				highlight = { enable = true },
				indent = { enable = true },
				debounce = 100,
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["ap"] = "@parameter.outer",
							["ip"] = "@parameter.inner",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>ps"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>pS"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- adds to jumplist
						goto_next_start = {
							["]a"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[a"] = "@parameter.inner",
						},
					},
				}
			}

		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies={"nvim-lua/plenary.nvim"},
		config = function() 
			function gpt_telescope_copy_file(prompt_bufnr) 
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				local entry = action_state.get_selected_entry()
				local filepath = entry and (entry.path or entry.filename)
				if filepath then
					local file = io.open(filepath, "r")
					if not file then
						print("Error: Could not open file: " .. filepath)
						return
					end
					local content = file:read("*a") 
					file:close()
					vim.fn.setreg("+", content)
					actions.close(prompt_bufnr)
				else
					print("No file selected to copy")
				end
			end
			require("telescope").setup {
				defaults = {
					mappings = {
						i = {
							["<C-c>"] = function(prompt_bufnr)
								gpt_telescope_copy_file(prompt_bufnr)
							end,
						},
						n = {
							["<C-c>"] = function(prompt_bufnr)
								gpt_telescope_copy_file(prompt_bufnr)
							end,
						},
					},
				},
			}
		end
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			-- { "<c-[>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		'akinsho/toggleterm.nvim', 
		version = "*", opts = {
			border = "double",	
			shell = machine.shell_path,
		}
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}

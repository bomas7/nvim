local map = vim.keymap.set
local opts = {noremap = true, silent = true}
local gpt = require("config.gpt")

local function extend_opts(desc)
	return vim.tbl_extend("force", opts, {desc=desc})
end

-- General
map("n", "<leader>w", ":w<CR>", extend_opts("Write buffer"))
map("n", "<leader>q", ":q<CR>", extend_opts("Quit"))
map("n", "<leader>fq", ":qa!<CR>", extend_opts("Force Quit"))
map("n", "<C-c>", ":%y+<CR>", extend_opts("Copy entire file"))
map("v", "<C-c>", "\"+y", extend_opts("Copy selection"))
map("n", "<leader>yf", [[:let @+ = expand('%')<CR>]], extend_opts("Copy file name"))
map('i', "<C-l>", "<C-w>", opts)
map("n", "+", "<C-a>", extend_opts("Increment"))
map("n", "-", "<C-x>", extend_opts("Decrement"))
map("n", "<C-s>", "@s", opts)

-- Buffer 
map("n", "<leader>b", ":split<CR>", extend_opts("Horizontal Buffer"))
map("n", "<leader>v", ":vsplit<CR>", extend_opts("Vertical Buffer"))
map("n", "<leader>h", "<C-w>h", extend_opts("Left Buffer"))
map("n", "<leader>j", "<C-w>j", extend_opts("Down Buffer"))
map("n", "<leader>k", "<C-w>k", extend_opts("Up Buffer"))
map("n", "<leader>l", "<C-w>l", extend_opts("Right Buffer"))
map("n", "<leader>,", "<C-w><", extend_opts("Decrease horizontal buffer"))
map("n", "<leader>.", "<C-w>>", extend_opts("Increase horizontal buffer"))
map("n", "<leader>-", "<C-w>-", extend_opts("Decrease vertical buffer"))
map("n", "<leader>=", "<C-w>+", extend_opts("Increase vertical buffer"))

map('n', '<leader>cl', gpt.clear_file, extend_opts("Clear current buffer content"))
map("n", "<leader>cf", gpt.codeforce_template, extend_opts("Insert CP template"))

-- Search
map('v', '/', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], extend_opts("Search for selection"))
map("n", "<leader>n", ":noh<CR>", extend_opts("Disable highlighting"))
map("n", "<leader>ca", gpt.toggle_ignore_case, extend_opts("Toggle Ignore Case"))
map("n", "<leader>ss", [[:%s//g<Left><Left>]], extend_opts("Search and Replace"))
map("n", "<leader>sl", function() gpt.search_and_replace_word({line = true}) end, extend_opts("SnR word line"))
map("n", "<leader>sr", function() gpt.search_and_replace_word() end, extend_opts("SnR word global"))

--=========== PLUGINS =============

-- Bufferline
for i = 1, 9 do
	map("n", "leader"..i, function()
		require("bufferline").go_to_buffer(i)
	end)
end
-- map("n", "<leader>x", gpt.close_tab, extend_opts("Delete buffer"))
map("n", "<leader>x", ":bdelete<CR>", extend_opts("Delete buffer"))
map("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", opts)
map("n", "<leader><Tab>", "<Cmd>BufferLineCyclePrev<CR>", extend_opts("Go back tab"))
map("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", extend_opts("Go back tab"))

-- Comments.nvim
local commentapi = require("Comment.api")
map("n", "<leader>/", commentapi.toggle.linewise.current, extend_opts("Comment line"))

-- NvimTree
local treeapi = require("nvim-tree.api")
map("n", "<leader>e", treeapi.tree.toggle, extend_opts("NvimTree Toggle"))
-- map("n", "<leader>b", gpt.open_buffer_nvimtree, extend_opts("Open buffer in NvimTree"))

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'NvimTree',
	callback = function()
		local opts = { noremap=true, silent=true, buffer=true }
		map('n', 'h', treeapi.node.navigate.parent_close, opts)
		map('n', 'l', treeapi.node.open.edit, opts)
		map('n', '=', gpt.zoom_in, opts)
		-- map('n', '-', gpt.zoom_out, opts)
		map('n', '0', gpt.open_directory_files, opts)
		-- map('x', 'o', gpt.open_visual_selection_files, opts)
		-- map('n', 'h', gpt.open_marked_files, opts)
	end
})

-- Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find file' })
map('n', '<leader>fs', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Telescope find definition' })
map('n', '<leader>fc', builtin.lsp_references, { desc = 'Telescope find calls' })
map('n', '<leader>fe', builtin.diagnostics, { desc = 'Telescope Diagnostics' })
map('n', '<leader>fw', builtin.current_buffer_fuzzy_find, { desc = 'Telescope find within buffer' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Telescope find buffer' })
map('n', '<leader>ft', gpt.find_directory, { desc = 'Telescope find directory' })

-- ToggleTerm
local term = require("config.terminals")
map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })
map('t', '<C-k>', '<Up>', opts)
map('t', '<C-j>', '<Down>', opts)
-- map("t", "<leader>q", "<C-\\><C-n>:close<CR>", extend_opts("Close term"))
map("n", "<leader>tq", ":close<CR>", extend_opts("Close term"))
-- map("n", "<leader>tf", term.toggle_float_term, extend_opts("Toggle float term"))
-- map("n", "<leader>td", term.toggle_horiz_term, extend_opts("Toggle horiz term"))
map("n", "<leader>rm", gpt.make_and_run, extend_opts("Make and Run"))

map("n", "<leader>tp", term.toggle_cp_term, extend_opts("Toggle CP term"))
map("n", "<leader>rd", gpt.run_cp, extend_opts("Default CP Run"))
map("n", "<leader>ri", function() gpt.run_cp({interactive = true, auto_input = false}) end, extend_opts("Interactive CP Run"))

-- LSP
map("n", "<leader>o", ":lua vim.diagnostic.open_float()<CR>", extend_opts("Hover LSP"))
map("n", "<leader>rl", gpt.reload_lsp, { desc = "Reload Buffer" })
map("n", "<leader>dl", gpt.disable_lsp, { desc = "Disable LSP clients" })

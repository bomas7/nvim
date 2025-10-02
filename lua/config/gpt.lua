local machine = require("config.machine")
local gpt = {}

function gpt.clear_file()
	vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
end

function gpt.close_tab()
	local api = vim.api
	local curr = api.nvim_get_current_buf()
	local fallback = nil

	for _, buf in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_loaded(buf)
			and api.nvim_buf_get_option(buf, "buflisted")
			and buf ~= curr
			and api.nvim_buf_get_option(buf, "filetype") ~= "NvimTree" then
			fallback = buf
			break
		end
	end

	if fallback then
		api.nvim_set_current_buf(fallback)
	else
		api.nvim_command("enew") 
	end

	api.nvim_buf_delete(curr, { force = false })
end

local Terminal = require("toggleterm.terminal").Terminal
function gpt.make_and_run()
	local build_run = Terminal:new({
		cmd = "make && ./main",
		direction = "float",
		close_on_exit = false,
		hidden = true
	})
	build_run:toggle()
end

-- START OF CP

local terminals = require("config.terminals")
function gpt.run_cp(opts)
	opts = opts or {}
	local interactive = opts.interactive or false
	local auto_input
	if opts.auto_input == nil then
		auto_input = true
	else 
		auto_input = opts.auto_input
	end

	if vim.bo.buftype == "" then
		vim.cmd("w")
	end

	local term = terminals.cp_term
	-- if term and term:is_open() then
	-- 	term:shutdown()
	-- end
	local ext = vim.fn.expand("%:e")
	local filepath, output
	if ext == "cpp" then
		filepath = vim.fn.expand("%:p")
		output = vim.fn.expand("%:t:r")
	else
		filepath = vim.fn.getcwd() .. "/main.cpp"
		output = "main"
	end


	local cmd = string.format("%s %s -o %s && ./%s", machine.cpp_compiler, filepath, output, output)
	if auto_input then
		cmd  = cmd .. " < input.txt"
	end
	if interactive then
		term:open()
		term:send("\n", true)
		term:send("clear", true)
		term:send(cmd, true)
		terminals.toggle_cp_term()
		return
	end
	local cmd_term = Terminal:new({
		cmd = cmd,
		direction = "float",
		close_on_exit = false,
	})

	cmd_term:open()
	-- term:open()

end


function gpt.codeforce_template()
	local function expand_path(path)
		return path:gsub("^~", vim.env.HOME)
	end
	local file_path = expand_path(machine.cp_template)
	-- print(file_path)
	local file = io.open(file_path, "r")
	if not file then
		print("Could not find template.")
		return
	end
	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end
	file:close()
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end
-- END OF CP

function gpt.reload_lsp()
	vim.cmd("edit") 
end

function gpt.disable_lsp()
	for _, client in pairs(vim.lsp.get_active_clients()) do
		client.stop()
	end
	vim.notify("LSP stopped. Now using Treesitter only.")
end

function gpt.zoom_in()
	local treeapi = require("nvim-tree.api")
	local node = treeapi.tree.get_node_under_cursor()

	if not node then
		vim.api.nvim_echo({{"No node under cursor", "WarningMsg"}}, false, {})
		return
	end

	local path = nil

	if node.type == "directory" then
		path = node.absolute_path
	elseif node.type == "file" then
		-- Use the parent directory of the file
		path = vim.fn.fnamemodify(node.absolute_path, ":h")
	else
		vim.api.nvim_echo({{"Unsupported node type", "WarningMsg"}}, false, {})
		return
	end

	if path then
		treeapi.tree.change_root(path)
	else
		vim.api.nvim_echo({{"Could not determine path", "WarningMsg"}}, false, {})
	end
end


function gpt.find_directory()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local Path = require("plenary.path")
	local function open_in_nvim_tree(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		actions.close(prompt_bufnr)

		local folder = vim.fn.fnamemodify(selection.value, ":p")
		-- Change cwd and open nvim-tree
		vim.cmd("cd " .. vim.fn.fnameescape(folder))
		require("nvim-tree.api").tree.open()
		require("nvim-tree.api").tree.change_root(folder)
	end

	pickers.new({}, {
		prompt_title = "Find Directory",
		finder = finders.new_oneshot_job({ "find", ".", "-type", "d" }, {}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(_, map)
			map("i", "<CR>", open_in_nvim_tree)
			map("n", "<CR>", open_in_nvim_tree)
			return true
		end,
	}):find()
end

function gpt.open_directory_files()
	local api = require("nvim-tree.api")
	local lib = require("nvim-tree.lib")

	-- Get the node under cursor
	local node = api.tree.get_node_under_cursor()
	if not node then return end

	-- Only proceed if node is a directory
	if node.nodes == nil then
		print("Not a directory")
		return
	end

	-- Iterate through child nodes (files and subfolders)
	for _, child in ipairs(node.nodes) do
		if not child.nodes then
			-- It's a file, open it in a buffer
			vim.cmd("edit " .. vim.fn.fnameescape(child.absolute_path))
		end
	end
end

function gpt.toggle_ignore_case()
	if vim.o.ignorecase then
		vim.o.ignorecase = false
		vim.o.smartcase = false
		vim.notify("ignorecase OFF", vim.log.levels.INFO)
	else
		vim.o.ignorecase = true
		vim.o.smartcase = true
		vim.notify("ignorecase ON (smartcase)", vim.log.levels.INFO)
	end
end

function gpt.search_and_replace_word(opts)
	local prefix = "%"
	if opts then
		if opts.line then
			prefix = "."
		end
	end

	local word = vim.fn.expand("<cword>")
	vim.ui.input({ prompt = "Replace '" .. word .. "' with: " }, function(replacement)
		if replacement == nil then
			-- print("Replacement cancelled.")
			return
		end
		local escaped_word = vim.fn.escape(word, "\\/")
		local escaped_replacement = vim.fn.escape(replacement, "\\/")
		vim.cmd(string.format("silent %ss/\\<%s\\>/%s/g", prefix, escaped_word, escaped_replacement))
		vim.cmd("noh")
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	end)
end

return gpt

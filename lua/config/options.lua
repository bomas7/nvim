vim.g.mapleader = " "
vim.o.updatetime=250
local opt = vim.opt

opt.wrap = false
opt.clipboard="unnamedplus"
opt.number = true         
opt.relativenumber = true  
opt.cursorline = true
vim.cmd('highlight! link CursorLineNr LineNr')
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

-- LSP 
vim.lsp.config.clangd = {
	filetypes = {"c", "cpp", "hpp", "h"},
	cmd = {"clangd"},
	root_markers = { "compile_commands.json"},
}

vim.lsp.config.pyright = {
	filetypes = {"python"},
	cmd = {"pyright-langserver", "--stdio"}
}

vim.lsp.enable("clangd")
vim.lsp.enable("pyright")


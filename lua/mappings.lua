require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
function replace_with_header_and_save()
    local path_to_header = vim.fn.expand("~/codeforces/header.cpp")  -- Specify the correct path
    local lines = vim.fn.readfile(path_to_header)
    if vim.tbl_isempty(lines) then
        print("Failed to read header.cpp")
        return
    end
    -- Clear the current buffer, set new content, and save
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.cmd('write')
end

function replace_with_cses_and_save()
    local path_to_header = vim.fn.expand("~/codeforces/cses.cpp")  -- Specify the correct path
    local lines = vim.fn.readfile(path_to_header)
    if vim.tbl_isempty(lines) then
        print("Failed to read cses.cpp")
        return
    end
    -- Clear the current buffer, set new content, and save
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.cmd('write')
end

function clear_current_file_and_save()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
    vim.cmd('write')
end

vim.api.nvim_set_keymap('n', '<leader>cf', '<cmd>lua replace_with_header_and_save()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>cs', '<cmd>lua replace_with_cses_and_save()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>cl', '<cmd>lua clear_current_file_and_save()<CR>', { noremap = true, silent = true })

map('n', '<leader>r', ':write<CR>:!g++ -std=c++20 main.cpp -o main && ./main < input.txt<CR>')

map('n', '<leader>m', ':write<CR>:!g++ -std=c++20 main.cpp -o main && ./main < input.txt > output.txt <CR>')
 
-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

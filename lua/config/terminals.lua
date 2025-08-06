local M = {}

local Terminal = require("toggleterm.terminal").Terminal
M.cp_term = Terminal:new({
	direction = "float", hidden = false, name = "CP Term"
})
-- M.float_term = Terminal:new({
-- 	direction = "float", close_on_exit = true, hidden = true, name = "Float Term"
-- })
-- M.horiz_term = Terminal:new({
-- 	direction = "horizontal", close_on_exit = true, hidden = true, name = "Horizontal Term", size = 80
-- })
function M.toggle_cp_term() M.cp_term:toggle() end
-- function M.toggle_float_term() M.float_term:toggle() end
-- function M.toggle_horiz_term() M.horiz_term:toggle() end

return M

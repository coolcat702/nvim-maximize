local M = {}

local function save_layout()
	M.layout = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local config = vim.api.nvim_win_get_config(win)
		table.insert(M.layout, { win = win, buf = buf, config = config })
	end
end

local function restore_layout()
	if not M.layout then
		return
	end
	local first_win = vim.api.nvim_get_current_win()
	local current_win = vim.api.nvim_get_current_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if win ~= current_win then
			pcall(vim.api.nvim_win_close, win, true)
		end
	end

	for _, entry in ipairs(M.layout) do
		if entry.win ~= first_win then
			if vim.api.nvim_buf_is_valid(entry.buf) then
				local new_win = vim.api.nvim_open_win(entry.buf, false, entry.config)
				vim.api.nvim_set_current_win(new_win)
			else
			end
		end
	end
	vim.api.nvim_set_current_win(first_win)
	M.layout = nil
end

function M.Open()
	if M.layout then
		return
	end
	save_layout()
	vim.cmd("on")
end

function M.Close()
	restore_layout()
end

function M.Toggle()
	if M.layout then
		M.Close()
	else
		M.Open()
	end
end

return M

----------------------------------------
-- Packman, the not-a-package-manager
--
-- Use nvim's default site and and only manage installing/loading/cleaning
-- packs as submodules.
----------------------------------------

local M = {}

local install_path = vim.fn.stdpath("config") .. "/site/"
vim.opt.packpath:append(install_path)
local packs_dir = "pack/simpoir/opt/"
local breadcrumbs = vim.fn.readdir(install_path .. packs_dir)

local function add_mod(pack, opts)
	local has_errors
	local p = string.gsub(pack, "^[^/]+/", "")
	local pack_dir = packs_dir .. p
	local abs_pack_dir = install_path .. pack_dir
	if #(vim.fn.glob(abs_pack_dir)) == 0 then
		print(vim.fn.system({
			"git",
			"-C",
			vim.fn.stdpath("config"),
			"submodule",
			"add",
			"--force",
			"https://github.com/" .. pack,
			"site/" .. pack_dir,
		}))
	end
	if #(vim.fn.readdir(abs_pack_dir)) == 0 then
		print("--> Pulling submodule pack for", p)
		vim.fn.system({
			"git",
			"-C",
			vim.fn.stdpath("config"),
			"submodule",
			"update",
			"--init",
			"site/pack/simpoir/opt/" .. p,
		})
	end
	if not has_errors then
		vim.cmd("redrawstatus")
	end
	print("loading pack", p)
	vim.cmd("redraw")
	if opts.eager then
		table.insert(vim.opt.runtimepath, 0, abs_pack_dir)
	end
	if not pcall(function()
		return vim.cmd("packadd! " .. p)
	end) then -- lazy pack load, so config globals are initialized
		print("Issue loading pack", p)
		has_errors = true
	end
	return has_errors
end

----------------------------------------
-- Bootstrap Site Packs
----------------------------------------
function M.setup(packs)
	local has_errors = false
	for i, pack in ipairs(packs) do
		local eager = false
		local config = function() end
		if type(pack) == "table" then
			local pack_opt = pack
			eager = pack_opt["eager"]
			config = pack_opt["config"] or config
		else
			pack = { pack }
		end
		-- can have multiple submods
		for _, subpack in ipairs(pack) do
			print("[", i, "/", #packs, "] Adding submodule pack for", subpack)
			has_errors = add_mod(subpack, { eager = eager }) or has_errors

			-- flag as used
			local subpack_name = subpack:gsub("^[^/]+/", "")
			for k, v in pairs(breadcrumbs) do
				if v == subpack_name then
					table.remove(breadcrumbs, k)
				end
			end
		end
		config()
	end
	vim.cmd("helptags ALL")
	if #breadcrumbs > 0 then
		local msg = "leftover packs: "
		for _, v in pairs(breadcrumbs) do
			msg = msg .. v .. " "
		end
		vim.cmd("redraw")
		print(msg)
	end
end

function M.PackUp()
	print("This is might take a while...")
	print(vim.fn.system({ "git", "-C", vim.fn.stdpath("config"), "submodule", "update", "--remote" }))
end

function M.PackClean()
	for _, v in pairs(breadcrumbs) do
		local dst = install_path .. packs_dir .. v
		print("Trimming", dst)
		vim.fn.delete(dst, "rf")
	end
end

vim.api.nvim_create_user_command("PackUp", M.PackUp, { desc = "Update plugin submodules" })
vim.api.nvim_create_user_command("PackClean", M.PackClean, { desc = "Clean unused plugins submodules" })

return M

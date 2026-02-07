
local ok, module = pcall(require, 'config.lazy');
if not ok then
	vim.notify('Error to load the module ' .. tostring(module), vim.log.levels.ERROR);
end;

require("eshoej.remap")
require("eshoej.set")

if vim.fn.filereadable(vim.fn.getcwd() .. '/project.godot') == 1 then
    local addr = './godot.pipe'
    vim.fn.serverstart(addr)
end

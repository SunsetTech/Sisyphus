local Module = require"Toolbox.Import.Module"

local Compiler = require"Sisyphus.Compiler"
local Template = Compiler.Objects.Template

return Template.Namespace{
	Functions = Module.Child"Functions";
}

local Module = require"Toolbox.Import.Module"

local Compiler = require"Sisyphus.Compiler"

return Compiler.Objects.Aliasable.Namespace{
	Data = Module.Child"Data";
}

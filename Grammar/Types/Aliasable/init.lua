local Module = require"Moonrise.Import.Module"

local Compiler = require"Sisyphus_Old.Compiler"

return Compiler.Objects.Aliasable.Namespace{
	Data = Module.Child"Data";
}

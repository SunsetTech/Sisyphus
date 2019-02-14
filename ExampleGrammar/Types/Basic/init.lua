local Module = require"Toolbox.Import.Module"

local Compiler = require"Sisyphus.Compiler"
local Basic = Compiler.Objects.Basic
local PEG = Compiler.Objects.Nested.PEG

return Basic.Namespace{
	Name = Module.Child"Name";
	Template = Module.Child"Template";
	Reparse = Module.Child"Reparse";
	Root = Basic.Type.Definition(
		PEG.Select{
			PEG.Variable.Canonical"Types.Basic.Reparse.WithTemplates",
			PEG.Variable.Canonical"Types.Aliasable.Data.String"
		}
	);
}

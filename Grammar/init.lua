local Module = require"Toolbox.Import.Module"

local Compiler = require"Sisyphus.Compiler"
local Template = Compiler.Objects.Template
local Aliasable = Compiler.Objects.Aliasable
local Variable = Compiler.Objects.Nested.PEG.Variable

return Template.Grammar(
	Aliasable.Grammar(
		Variable.Canonical"Types.Basic.Root",
		Module.Child"Types.Aliasable",
		Module.Child"Types.Basic",
		nil,
		{
			Files = {};
		}
	),
	Module.Child"Types.Templates"
)

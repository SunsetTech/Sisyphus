local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"
local Template = Compiler.Objects.Template
local Nested = Compiler.Objects.Nested
local PEG = Nested.PEG
local Variable = PEG.Variable

local Syntax = Import.Module.Relative"Objects.Syntax"

return Template.Namespace{
	Concat = Template.Definition(
		Compiler.Objects.CanonicalName("Data",Compiler.Objects.CanonicalName"String"),
		Syntax.Tokens{PEG.Pattern"Concat", Syntax.ArgumentArray(Variable.Canonical"Types.Aliasable.Data.String")},
		function(...)
			return table.concat{...}
		end
	);
}

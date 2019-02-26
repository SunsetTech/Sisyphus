local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"
local Template = Compiler.Objects.Template
local Nested = Compiler.Objects.Nested
local PEG = Nested.PEG
local Variable = PEG.Variable

local Syntax = Import.Module.Relative"Objects.Syntax"
local Construct = Import.Module.Relative"Objects.Construct"

return Template.Namespace{
	Join = Template.Definition(
		Compiler.Objects.CanonicalName("Data",Compiler.Objects.CanonicalName"String"),
		Syntax.Tokens{
			Syntax.Optional(PEG.Pattern"Join"), 
			Construct.ArgumentArray(Variable.Canonical"Types.Aliasable.Data.String")
		},
		function(...)
			return table.concat{...}
		end
	);
}

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
		PEG.Debug(Syntax.Tokens{
			PEG.Optional(PEG.Pattern"Join"), 
			Variable.Canonical"Types.Aliasable.Data.Array<Data.String>"
		}),
		function(Arguments)
			return table.concat(Arguments)
		end
	);
}

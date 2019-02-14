local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"
local Basic = Compiler.Objects.Basic
local Nested = Compiler.Objects.Nested
local PEG = Nested.PEG
local Variable = PEG.Variable

local Syntax = Import.Module.Relative"Objects.Syntax"
local Patterns = Import.Module.Relative"Objects.Patterns"
local Pattern = Import.Module.Relative"Pattern"

local Vlpeg = require"Sisyphus.Vlpeg"

return Basic.Namespace{
	Part = Basic.Type.Definition(
		PEG.Capture(Syntax.Atleast(1, Patterns.Alpha))
	);
	
	Specifier = Basic.Type.Definition(
		Syntax.Array(Variable.Canonical"Types.Basic.Name.Part", PEG.Pattern".", Vlpeg.Sequence)
	);

	Canonical = Basic.Type.Definition(
		PEG.Apply(
			Variable.Canonical"Types.Basic.Name.Specifier",
			function(...)
				local Canonical
				for _, Part in pairs{...} do
					Canonical = Compiler.Objects.CanonicalName(Part, Canonical)
				end
				return Canonical
			end
		)
	);

	Target = Basic.Type.Definition(
		PEG.Apply(
			Variable.Canonical"Types.Basic.Name.Specifier",
			function(...)
				local Parts = {...}
				local Root = Compiler.Objects.CanonicalName(Parts[1])
				local Target = Root
				for Index = 2, #Parts do -- 1,2,3 {1,{2,{3}}}
					local Part = Parts[Index]
					Target.Namespace = Compiler.Objects.CanonicalName(Parts[Index])
					Target = Target.Namespace
				end
				return Root
			end
		)
	);
}

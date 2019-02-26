local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"

local Aliasable = Compiler.Objects.Aliasable
local Nested = Compiler.Objects.Nested
local PEG = Nested.PEG
local Variable = PEG.Variable

local Syntax = Import.Module.Relative"Objects.Syntax"

return Aliasable.Namespace {
	String = Aliasable.Type.Definition(
		Variable.Child"Syntax",
		function(...)
			return ...
		end,
		Nested.Grammar{
			Delimiter = PEG.Pattern'"';
			Open = Variable.Sibling"Delimiter";
			Close = Variable.Sibling"Delimiter";
			Contents = PEG.Capture(
				Syntax.All(
					PEG.Dematch(
						PEG.Pattern(1),
						Variable.Sibling"Delimiter"
					)
				)
			);
			PEG.Sequence{Variable.Child"Open", Variable.Child"Contents", Variable.Child"Close"};
		}
	)
}

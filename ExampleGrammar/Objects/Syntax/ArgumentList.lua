local Import = require"Toolbox.Import"
local Tools = require"Toolbox.Tools"

local Compiler = require"Sisyphus.Compiler"
local Vlpeg = require"Sisyphus.Vlpeg"
local Pattern = Import.Module.Relative"Pattern"

return Compiler.Object(
	"Nested.PEG.Syntax.ArgumentList", {
		Construct = function(self, Patterns)
			Tools.Error.CallerAssert(Patterns, "Where are they", 1)
			self.Patterns = Compiler.Objects.Array("Nested.PEG", Patterns)
		end;

		Decompose = function(self, Canonical)
			local ListPattern = Pattern.Syntax.List(self.Patterns(Canonical), Pattern.Syntax.Centered(Pattern.Syntax.Optional","))
			local Delimited = Pattern.Syntax.Delimited(
				Vlpeg.Pattern"<",
				ListPattern,
				Vlpeg.Pattern">"
			)
			return Vlpeg.Select(
				Delimited,
				ListPattern
			)
		end;
		
		Copy = function(self)
			return (-self.Patterns).Items
		end;
	}
)

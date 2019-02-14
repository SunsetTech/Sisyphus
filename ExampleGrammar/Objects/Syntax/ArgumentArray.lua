local Import = require"Toolbox.Import"

local Vlpeg = require"Sisyphus.Vlpeg"
local Compiler = require"Sisyphus.Compiler"

local Pattern = Import.Module.Relative"Pattern"

return Compiler.Object(
	"Nested.PEG.Syntax.ArgumentArray", {
		Construct = function(self, ArgumentPattern)
			self.ArgumentPattern = ArgumentPattern
		end;

		Decompose = function(self, Canonical)
			return Pattern.Syntax.Delimited(
				Vlpeg.Pattern"<",
				Pattern.Syntax.Array(
					self.ArgumentPattern(Canonical), 
					Pattern.Syntax.Centered(Pattern.Syntax.Optional",")
				),
				Vlpeg.Pattern">"
			)
		end;
		
		Copy = function(self)
			return -self.ArgumentPattern
		end;
	}
)

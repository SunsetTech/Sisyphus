local Import = require"Toolbox.Import"

local Compiler = require"Sisyphus.Compiler"

local Pattern = Import.Module.Relative"Pattern"

return Compiler.Object(
	"Nested.PEG.Syntax.Array", {
		Construct = function(self, ItemPattern, SeperatorPattern, ConcatenatorFunction)
			self.ItemPattern = ItemPattern
			self.SeperatorPattern = SeperatorPattern
			self.ConcatenatorFunction = ConcatenatorFunction
		end;

		Decompose = function(self, Canonical)
			return Pattern.Syntax.Array(self.ItemPattern(Canonical), self.SeperatorPattern(Canonical), self.ConcatenatorFunction)
		end;
		
		Copy = function(self)
			return -self.ItemPattern, -self.SeperatorPattern, self.ConcatenatorFunction
		end;
	}
)

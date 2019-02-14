local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.Immediate", {
		Construct = function(self, InnerPattern, Function)
			self.InnerPattern = InnerPattern
			self.Function = Function
		end;
		Decompose = function(self, Canonical)
			return Vlpeg.Immediate(
				self.InnerPattern(Canonical), 
				self.Function
			)
		end;
		Copy = function(self)
			return -self.InnerPattern, self.Function
		end;
	}
)

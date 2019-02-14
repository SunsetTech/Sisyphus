local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.Apply", {
		Construct = function(self, SubPattern, Value)
			self.SubPattern = SubPattern
			self.Value = Value
		end;
		Decompose = function(self, Canonical)
			return Vlpeg.Apply(
				self.SubPattern(Canonical), 
				self.Value
			)
		end;
		Copy = function(self)
			return -self.SubPattern, self.Value
		end;
	}
)

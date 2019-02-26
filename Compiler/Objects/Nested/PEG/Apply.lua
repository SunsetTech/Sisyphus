local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
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

		ToString = function(self)
			return tostring(self.SubPattern) .."/".. tostring(self.Value)
		end;
	}
)

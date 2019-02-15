local Import = require"Toolbox.Import"

local Vlpeg = Import.Module.Relative"Vlpeg"

local Object = Import.Module.Relative"Object"

return Object(
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

		ToString = function(self)
			return tostring(self.Function) .."(".. tostring(self.InnerPattern) ..")"
		end;
	}
)

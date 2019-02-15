local lpeg = require"lpeg"
local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.Capture", {
		Construct = function(self, SubPattern)
			self.SubPattern = SubPattern
		end;
		
		Decompose = function(self, Canonical)
			return lpeg.C(self.SubPattern(Canonical))
		end;
		
		Copy = function(self)
			return -self.SubPattern
		end;

		ToString = function(self)
			return "(".. self.SubPattern ..")"
		end;
	}
)

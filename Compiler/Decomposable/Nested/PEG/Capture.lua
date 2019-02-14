local lpeg = require"lpeg"
local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
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
	}
)

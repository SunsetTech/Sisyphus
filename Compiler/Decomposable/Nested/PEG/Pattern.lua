local lpeg = require"lpeg"

local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.Pattern", {
		Construct = function(self, Pattern)
			self.Pattern = Pattern
		end;
		Decompose = function(self, Canonical)
			return lpeg.P(self.Pattern)
		end;
		Copy = function(self)
			return self.Pattern
		end;
	}
)

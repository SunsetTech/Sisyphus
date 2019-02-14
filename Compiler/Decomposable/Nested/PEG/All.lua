local lpeg = require"lpeg"

local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.All", {
		Construct = function(self, Pattern)
			self.Pattern = Pattern
		end;

		Decompose = function(self, Canonical)
			return self.Pattern(Canonical)^0
		end;

		Copy = function(self)
			return -self.Pattern
		end;
	}
)

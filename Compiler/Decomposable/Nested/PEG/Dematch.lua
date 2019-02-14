local Import = require"Toolbox.Import"
local lpeg = require"lpeg"

local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.Dematch", {
		Construct = function(self, Pattern, Without)
			self.Pattern = Pattern
			self.Without = Without
		end;

		Decompose = function(self, Canonical)
			assert(Canonical)
			return self.Pattern(Canonical) - self.Without(Canonical)
		end;
		
		Copy = function(self)
			return -self.Pattern, -self.Without
		end;
	}
)

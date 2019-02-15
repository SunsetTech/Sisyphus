local Import = require"Toolbox.Import"
local lpeg = require"lpeg"

local Object = Import.Module.Relative"Object"

return Object(
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

		ToString = function(self)
			return self.Pattern .."-".. self.Without
		end;
	}
)

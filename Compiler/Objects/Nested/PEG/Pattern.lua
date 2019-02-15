local lpeg = require"lpeg"

local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"

return Object(
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

		ToString = function(self)
			return tostring(self.Pattern)
		end;
	}
)

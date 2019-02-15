local lpeg = require"lpeg"

local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"

return Object(
	"Nested.PEG.All", {
		Construct = function(self, InnerPattern)
			self.InnerPattern = InnerPattern
		end;

		Decompose = function(self, Canonical)
			return self.InnerPattern(Canonical)^0
		end;

		Copy = function(self)
			return -self.InnerPattern
		end;

		ToString = function(self)
			return self.InnerPattern .."*"
		end;
	}
)

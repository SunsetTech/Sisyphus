local lpeg = require"lpeg"

local Import = require"Toolbox.Import"
local Object = Import.Module.Relative"Object"
local CanonicalName = Import.Module.Relative"CanonicalName"

return Object(
	"Nested.PEG.Variable.Sibling", {
		Construct = function(self, Target)
			self.Target = Target
		end;

		Decompose = function(self, Canonical)
			return lpeg.V(
				CanonicalName(self.Target, Canonical.Namespace)()
			)
		end;

		Copy = function(self)
			return self.Target
		end;

		ToString = function(self)
			return "^".. self.Target
		end;
	}
); 

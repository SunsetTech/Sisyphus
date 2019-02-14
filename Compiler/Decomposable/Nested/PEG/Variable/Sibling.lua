local lpeg = require"lpeg"

local Import = require"Toolbox.Import"
local DecomposableObject = Import.Module.Relative"DecomposableObject"
local CanonicalName = Import.Module.Relative"CanonicalName"

return DecomposableObject(
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
	}
); 

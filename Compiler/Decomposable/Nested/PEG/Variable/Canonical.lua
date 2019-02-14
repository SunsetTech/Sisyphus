local lpeg = require"lpeg"

local Import = require"Toolbox.Import"
local DecomposableObject = Import.Module.Relative"DecomposableObject"

return DecomposableObject(
	"Nested.PEG.Variable.Canonical", {
		Construct = function(self, Target)
			self.Target = Target
		end;

		Decompose = function(self)
			return lpeg.V(self.Target)
		end;

		Copy = function(self)
			return self.Target
		end;

		ToString = function(self)
			return "[".. self.Target .."]"
		end;
	}
)

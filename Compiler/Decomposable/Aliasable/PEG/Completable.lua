local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Transform = Import.Module.Relative"Transform"

return DecomposableObject(
	"Nested.PEG.Completable", {
		Construct = function(self, Pattern, Function)
			self.Pattern = -Pattern
			self.Function = Function
		end;
		Decompose = function(self, Canonical)
			return Transform.Completable(
				self.Pattern(Canonical), 
				self.Function
			)
		end;
		Copy = function(self)
			return self.Pattern, self.Function
		end;
	}
)

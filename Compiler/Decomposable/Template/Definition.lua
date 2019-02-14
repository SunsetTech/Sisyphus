local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Aliasable = Import.Module.Relative"Decomposable.Aliasable"

return DecomposableObject(
	"Template.Definition", {
		Construct = function(self, Basetype, Pattern, Function)
			assert(Basetype)
			self.Basetype = Basetype
			self.Pattern = Pattern
			self.Function = Function
		end;

		Decompose = function(self)
			return Aliasable.Type.Definition(
				self.Pattern,
				self.Function
			)
		end;
	}
)

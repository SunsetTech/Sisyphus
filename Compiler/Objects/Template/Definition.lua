local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"
local Aliasable = Import.Module.Relative"Objects.Aliasable"

return Object(
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

local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Map = Import.Module.Relative"Decomposable.Map"
local Aliasable = Import.Module.Relative"Decomposable.Aliasable"

return DecomposableObject(
	"Template.Namespace", {
		Construct = function(self, Children, Base)
			self.Base = Base or Aliasable.Namespace()
			self.Children = Map({"Template.Namespace", "Template.Definition"}, Children or {})
		end,

		Decompose = function(self)
			return 
				Aliasable.Namespace(self.Children())
				+ self.Base
		end;

		Copy = function(self)
			return (-self.Children).Entries, self.Base
		end;
	}
)

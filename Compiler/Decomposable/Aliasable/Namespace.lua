local Import = require"Toolbox.Import"

local DecomposableObject = Import.Module.Relative"DecomposableObject"
local Map = Import.Module.Relative"Decomposable.Map"
local Basic = Import.Module.Relative"Decomposable.Basic"

return DecomposableObject(
	"Aliasable.Namespace", {
		Construct = function(self, Children, Base)
			self.Base = Base or Basic.Namespace()
			self.Children = Map({"Aliasable.Namespace", "Aliasable.Type.Definition"}, Children or {})
		end;

		Decompose = function(self) -- into a Basic.Namespace
			return 
				Basic.Namespace(self.Children())
				+ self.Base
		end;

		Copy = function(self)
			return (-self.Children).Entries, -self.Base
		end;

		Merge = function(Into, From)
			Into.Base = Into.Base + From.Base
			Into.Children = Into.Children + From.Children
		end;
	}
)

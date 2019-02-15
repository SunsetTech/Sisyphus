local Import = require"Toolbox.Import"

local Object = Import.Module.Relative"Object"
local Map = Import.Module.Relative"Objects.Map"
local Basic = Import.Module.Relative"Objects.Basic"

return Object(
	"Aliasable.Namespace", {
		Construct = function(self, Children, Base)
			self.Base = Base or Basic.Namespace()
			self.Children = Map({"Aliasable.Namespace", "Aliasable.Type.Definition"}, Children or {})
		end;

		Decompose = function(self) -- into a Basic.Namespace
			return 
				self.Base
				+ Basic.Namespace(self.Children())
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
